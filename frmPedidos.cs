using System;
using MegaRosita.Capa.Comun;
using System.Drawing;
using System.Data;
using System.Windows.Forms;
using System.Collections.Generic;
using MegaRosita.Capa.Entidades;
using System.Drawing.Printing;
using MegaRosita.Capa.Logica;
using System.Linq;
namespace MegaRosita.Capa.Aplicacion
{
    public partial class FrmPedidos : Form
    {
        public string tipoDatos = "";
        public int filaSeleccionada = -1;
        public string mesas_local = "";
        public ControlMesas principal;
        public bool condicion_local = false;
        public string codigoOrdenLocal = "";
        public string tipoRegistro_local = "-";
        string xEstado = string.Empty;
        DataTable tabla;
        DataView vista;
        BindingSource bs;
        string[] listaDetalle;
        Mensajes men = new Mensajes();
        Conexion xconexion = new Conexion();
        LogProducto obj = new LogProducto();
        public string xPersonal { get; set;}
        public FrmPedidos()
        {
            InitializeComponent();
            lblidCliente.Text = "";
        }
        public void imprimirGuia()
        {
            bool Escorrecto = false;
            string xidsub = string.Empty;
            decimal xdife = 0;
            if (btneditar.Visible == false)
            {
                foreach (DataGridViewRow row in gvlista.Rows)
                {
                    xidsub = Convert.ToString(row.Cells[10].Value);
                    if (xidsub == "1")
                    {
                        Escorrecto = true;
                        break;
                    }
                    else
                    {
                        Escorrecto = false;
                    }
                }
                if (Escorrecto == true)
                {
                    impresion();
                }
                else
                {
                    //
                }
            }
            else
            {
                foreach (DataGridViewRow row in gvlista.Rows)
                {
                    xidsub = Convert.ToString(row.Cells[10].Value);
                    xdife= Convert.ToDecimal(row.Cells[12].Value);
                    if (xidsub == "1" && xdife>=1)
                    {
                        Escorrecto = true;
                        break;
                    }
                    else if (xidsub == "1" && string.IsNullOrEmpty(Convert.ToString(row.Cells[11].Value)))
                    {
                        Escorrecto = true;
                        break;
                    }
                    else
                    {
                        Escorrecto = false;
                    }
                }
                if (Escorrecto == true)
                {
                    impresion();
                }
                else
                {
                    //
                }
            }
        }
        public void impresion()
        {
            try
            {
                PaperSize pageSize;
                pageSize = new PaperSize("ILIMITADO", 80, 3276);
                PrintDocument formulario = new PrintDocument();
                formulario.PrintController = new StandardPrintController();
                formulario.PrintPage += new PrintPageEventHandler(datoscliente);
                formulario.PrinterSettings.PrinterName =xconexion.predeterminado();
                formulario.Print();
                ////visualizar la impresion
                //PrintPreviewDialog printPreviewDialog1 = new PrintPreviewDialog();
                //printPreviewDialog1.Document = formulario;
                //printPreviewDialog1.ShowDialog();
            }
            catch (Exception ex)
            {
                ex.ToString();
                MessageBox.Show("El servidor de la Impresora Esta apagado Favor de Encenderla" + ex.ToString(), "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        private string FormatearMonto(string numero)
        {
            int largotexto;
            string result = "";
            string espacios = "";
            int xnum = (numero.Length);
            largotexto = (9 - xnum);
            for (int i = 0; i < largotexto; i++)
            {
                espacios = espacios + " ";
            }
            result = espacios + numero;
            return result;
        }
        public void datoscliente(object obj, PrintPageEventArgs ev)
        {
            Font fuente = new Font("Arial", 8);
            Font fuente2 = new Font("Arial", 8, FontStyle.Bold);
            Font fuente3 = new Font("Arial", 9, FontStyle.Bold);
            Font fuente4 = new Font("Arial", 10, FontStyle.Bold);
            float pos_x = 0;
            float pos_y = 0;
            string empresa, sdireccion, stelefono, xnroOrden,
                fecha, xmesa, xcliente, xobs, vendedor = string.Empty;
            empresa = "<TICKET DE DESPACHO SAPECHI>";
            sdireccion = xconexion.xDireccion;
            stelefono = xconexion.xTelefono;
            xnroOrden = "Nro Orden: " + txtSerie.Text + "-" + txtCorrelativo.Text;
            fecha = "Fecha: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");
            xmesa = "Mesas: " + txtMesa.Text;
            xcliente = "Cliente: " + txtCliente.Text;
            xobs = "OBS: " + txtObservacion.Text;
            vendedor = "Mozo: " + xPersonal.ToString();
            pos_y = 0;
            pos_x =5;
            ev.Graphics.DrawString(empresa.ToString(), fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 22;
            pos_x = 0;
            ev.Graphics.DrawString(sdireccion.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 0;
            ev.Graphics.DrawString(stelefono.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("*************************************************************************************************************************************", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 0;
            ev.Graphics.DrawString(xnroOrden, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString(fecha, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString(xmesa, fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            int maxCliente = 39;
            string textosCliente = xcliente;
            if (textosCliente.Length > maxCliente)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosCliente.Length; longitudTexto > maxCliente; longitudTexto -= maxCliente)
                {
                    ev.Graphics.DrawString(textosCliente.Substring(caracterActual, maxCliente), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxCliente;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosCliente.Substring(caracterActual, textosCliente.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosCliente, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 17;
            ev.Graphics.DrawString(vendedor, fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 25;
            ev.Graphics.DrawString("Cantidad", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 50;
            ev.Graphics.DrawString("Descripcion", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 0;
            pos_y = pos_y + 8;
            ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            string textos = string.Empty;
            int maxCart = 31;
            double cantidad = 0;
            foreach (DataGridViewRow fila in gvlista.Rows)
            {
                if ((Convert.ToString(fila.Cells[10].Value) == "1" && string.IsNullOrEmpty(Convert.ToString(fila.Cells[11].Value))) || (Convert.ToString(fila.Cells[10].Value) == "1" && Convert.ToDecimal(fila.Cells[12].Value) >= 1))
                {
                    textos = Convert.ToString(fila.Cells[2].Value);
                    if (btneditar.Visible == false)
                    {
                        cantidad = Convert.ToDouble(fila.Cells[4].Value);
                    }
                    else
                    {
                        if (Convert.ToString(fila.Cells[10].Value) == "1" && string.IsNullOrEmpty(Convert.ToString(fila.Cells[11].Value)))
                        {
                            cantidad = Convert.ToDouble(fila.Cells[4].Value);
                        }
                        else
                        {
                            if (Convert.ToString(fila.Cells[10].Value) == "1" && Convert.ToDecimal(fila.Cells[12].Value) >= 1)
                            {
                                cantidad = Convert.ToDouble(fila.Cells[12].Value);
                            }
                            else
                            {
                                //
                            }
                        }
                    }
                    pos_y = pos_y + 19;
                    pos_x = 0;
                    ev.Graphics.DrawString(cantidad.ToString("N2"), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
                    pos_x = 50;
                    if (textos.Length > maxCart)
                    {
                        int caracterActual = 0;
                        for (int longitudTexto = textos.Length; longitudTexto > maxCart; longitudTexto -= maxCart)
                        {
                            ev.Graphics.DrawString(textos.Substring(caracterActual, maxCart).ToUpper(), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
                            caracterActual += maxCart;
                            pos_y = pos_y + 19;
                            pos_x = 0;
                        }
                        ev.Graphics.DrawString(textos.Substring(caracterActual, textos.Length - caracterActual), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
                    }
                    else
                    {
                        ev.Graphics.DrawString(textos.ToString().ToUpper(), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
                        //pos_y = pos_y + 19;
                    }
                    pos_x = 0;
                    pos_y = pos_y + 8;
                    ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                }
            }
            pos_y = pos_y + 20;
            pos_x = 0;
            int maxOBS =38;
            string textosOBS = xobs;
            if (textosOBS.Length > maxOBS)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosOBS.Length; longitudTexto > maxOBS; longitudTexto -= maxOBS)
                {
                    ev.Graphics.DrawString(textosOBS.Substring(caracterActual, maxOBS), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxOBS;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosOBS.Substring(caracterActual, textosOBS.Length - caracterActual), fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosOBS, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("Items: " + lblItemB.Text, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("Nota:Ticket de Control Interno para el Area de Logistica", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
        }
        public FrmPedidos(string mesas_p,ControlMesas frm, bool condicionUpdate, string codigoPedido_p, string tipo_Registro)
        {
            InitializeComponent();
            this.mesas_local = mesas_p;
            this.condicion_local = condicionUpdate;
            this.tipoRegistro_local = tipo_Registro;
            principal = frm;
            gvlista.Rows.Clear();
            DataGridViewButtonColumn btn = new DataGridViewButtonColumn();
            btn.Name = "btnEliminar";
            btn.HeaderText = "Eliminar";
            btn.UseColumnTextForButtonValue = true;
            btn.Text = "Eliminar";
            btn.ToolTipText = "Eliminar";
            gvlista.Columns.Add(btn);
            txtMesa.Enabled = false;
            txtSerie.Enabled = false;
            txtCorrelativo.Enabled = false;
            if (condicion_local)
            {//Actualizar
                codigoOrdenLocal = codigoPedido_p;
                btneliminar.Enabled = true;
                btnConfiguracionMesas.Visible = true;
                listar();
                calcularImporteTablaOrden();
                sumarTotal();
                lblItemB.Text = gvlista.Rows.Count.ToString();
                btnguardar.Visible = false;
                btnnuevo.Enabled = false;
                btneditar.Visible= true;
                //linkenviar.Visible = true;
            }
            else
            {//Guardar
                if (!mesas_p.Equals(""))
                {
                    string xvalmesa = string.Empty;
                    string mesa = string.Empty;
                    string[] mesas = mesas_local.Split(',');
                    int cantidadMesas = mesas.Length;
                    for (int i = 0; i < cantidadMesas; i++)
                    {
                        mesa = mesas[i].ToString();
                        xvalmesa += "MESA " + mesa + " ,";
                    }
                    txtMesa.Text = xvalmesa.Substring(0, xvalmesa.Length - 1);
                }
                else
                {
                    txtMesa.Text = "";
                }
                generadorTicket();
                btnConfiguracionMesas.Visible = false;
                btnguardar.Visible =true;
                btnnuevo.Enabled =true;
                btneditar.Visible =false;
                btneliminar.Enabled =false;
                //linkenviar.Visible =false;
            }  
        }
        public void limpiarCabeceras()
        {
            txtSerie.Text = "0001";
            txtCorrelativo.Text = "";
            txtMesa.Text = "";
            txtCliente.Text = "PUBLICO GENERAL";
        }
        public void listar()
        {
            gvlista.Rows.Clear();
            gvlista.DataSource = null;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("cargarDatosOrdenPedido", "@IdOrden", codigoOrdenLocal);
            if (rpt != "")
            {
                limpiarCabeceras();
                string[] listas = rpt.Split('[');
                CrearCabecerasPedidos(listas[0]);//Llenado de cabeceras
                CrearTablasPedidos(gvlista, listas[1]);//Llenando los detalles
            }
        }
        public void CrearTablasPedidos(DataGridView gridView, string data)
        {
            string[] registros = data.Split('¬');
            string[] cabezeras = registros[0].Split('|');
            int nRegistros = registros.Length;
            string[] campos;
            for (int i = 0; i < nRegistros; i++)
            {
                campos = registros[i].Split('|');
                if (campos[0] == "~") break;
                else
                {
                    gvlista.Rows.Add(campos[0].ToString(), campos[1].ToString(), campos[2].ToString(), campos[3].ToString(), campos[4].ToString(),
                    campos[5].ToString(), campos[6].ToString(), campos[7].ToString(), campos[8].ToString(), campos[9].ToString(), campos[10].ToString(),campos[4].ToString(),"0");
                }
            }
        }
        public void CrearCabecerasPedidos(string data)
        {
            xEstado = string.Empty;
            string[] registros = data.Split('¬');
            string[] cabezeras = registros[0].Split('|');
            int ncampos = cabezeras.Length;
            int nRegistros = registros.Length;
            string[] campos;
            for (int i = 0; i < nRegistros; i++)
            {
                campos = registros[i].Split('|');
                if (campos[0] == "~") break;
                else
                {
                    if (campos[0].ToString().Equals(codigoOrdenLocal))
                    {
                        lblidCliente.Text = campos[1].ToString();
                        txtCliente.Text = campos[2].ToString();
                        txtfecha.Text = campos[3].ToString();
                        txthorafin.Text = campos[4].ToString();
                        txtSerie.Text = campos[5].ToString();
                        txtCorrelativo.Text = campos[6].ToString();
                        txtMesa.Text = campos[7].ToString();
                        txtObservacion.Text = campos[8].ToString();
                        xEstado= campos[10].ToString();
                    }
                }
            }
            if (xEstado.Equals("ENVIADO"))
            {
                //linkenviar.Text = "Corregir Envio";
                gvlista.ReadOnly = true;
                btnagregar.Enabled = false;
                btnrestar.Enabled = false;
                gvlista.Columns[13].Visible = false;
                btneliminar.Enabled = false;
                btneditar.Enabled = false;
                btnConfiguracionMesas.Enabled = false;
            }
            else
            {
                //linkenviar.Text = "Enviar Caja";
            }
        }
        public void dgv(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            TextBox texto2 = new TextBox();
            texto2.Text = "";
            for (int i = 0; i < texto2.Text.Length; i++)
            {
                if (texto2.Text[i] == '.')
                    IsDec = true;

                if (IsDec && nroDec++ >= 2)
                {
                    e.Handled = true;
                    return;
                }
            }
            if (e.KeyChar >= 48 && e.KeyChar <= 57)
                e.Handled = false;
            else if (e.KeyChar == 46)
                e.Handled = (IsDec) ? true : false;
            else
                e.Handled = true;
        }
        public void generadorTicket()
        {
            string xdata = string.Empty;
            AccesoDatos daSQL = new AccesoDatos("con");
            xdata = daSQL.ejecutarComando("correlativoNroTicket", "@dato", txtSerie.Text);
            if (!xdata.Equals(""))
            {
                txtCorrelativo.Text = xdata;
            }
            else
            {
                txtCorrelativo.Text = "00000001";
            }
        }
        private void FrmPedidos_Load(object sender, EventArgs e)
        {
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("MRDuenasB");
            string[] listas = rpt.Split('[');
            string[] titulos = listas[0].Split('|');
            string[] listaCabezeras = listas[1].Split('¬');
            listaDetalle = listas[2].Split('¬');
            TreeNode raiz = tvwcabezera.Nodes.Add(titulos[0]);
            int nCabezeras = listaCabezeras.Length;
            string[] campos;
            for (int i = 0; i < nCabezeras; i++)
            {
                campos = listaCabezeras[i].Split('|');
                if (campos[0] != "~") raiz.Nodes.Add(campos[0], campos[1]);
                else break;
            }
            tvwcabezera.ExpandAll();
            men.alternarcolorB(gvproducto);
            men.alternarcolor(gvlista);

            txtcodigo.Focus();
        }
        public void ocultarColumna()
        {
            gvproducto.Columns[0].Visible = false;
            gvproducto.Columns[5].Visible = false;
            gvproducto.Columns[6].Visible = false;
            gvproducto.Columns[1].Width =275;
            gvproducto.Columns[4].Width =80;
            gvproducto.Columns[2].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvproducto.Columns[3].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
        }
        private void tvwcabezera_AfterSelect(object sender, TreeViewEventArgs e)
        {
            //if(linkenviar.Text =="Corregir Envio")
            //{
            //    MessageBox.Show("La orden de pedido ya fue enviado a caja...Corrija la orden o ingrese uno nuevo","AVISO",MessageBoxButtons.OK,MessageBoxIcon.Warning);
            //}
            //else
            //{
            if (e.Node.Level > 0)
            {
                tabla = new DataTable();
                tabla.Columns.Add(new DataColumn("ID", typeof(string)));
                tabla.Columns.Add(new DataColumn("Descripcion", typeof(string)));
                tabla.Columns.Add(new DataColumn("Precio", typeof(string)));
                tabla.Columns.Add(new DataColumn("Cantidad", typeof(string)));
                tabla.Columns.Add(new DataColumn("UM", typeof(string)));
                tabla.Columns.Add(new DataColumn("Costo", typeof(string)));
                tabla.Columns.Add(new DataColumn("ENVIAR", typeof(string)));
                var nDetalles = listaDetalle.Length;
                var idCabezera = e.Node.Name;
                string[] campos;
                int n = 7;//listaDetalle[2].Split('|').Length - 1;
                DataRow drw;
                for (int i = 0; i < nDetalles; i++)
                {
                    campos = listaDetalle[i].Split('|');
                    if (idCabezera == campos[n])
                    {
                        drw = tabla.NewRow();
                        drw[0] = campos[0].ToString();
                        drw[1] = campos[1].Replace("&amp;", "&");
                        drw[2] = campos[2].ToString();
                        drw[3] = campos[3].ToString();
                        drw[4] = campos[4].ToString();
                        drw[5] = campos[5].ToString();
                        drw[6] = campos[6].ToString();
                        tabla.Rows.Add(drw);
                    }
                }
                vista = tabla.DefaultView;
                bs = new BindingSource();
                bs.DataSource = tabla;
                gvproducto.DataSource = bs;
                ocultarColumna();
                txtBusqueda.Text = "";
                lblItems.Text = gvproducto.Rows.Count.ToString();
                txtBusqueda.Enabled = true;
            }
            //}
        }
        public void buscar()
        {
            if (gvproducto.DataSource == null)
            {
                //
            }
            else
            {
                if (txtBusqueda.Text != "")
                {
                    string campo = "Descripcion";
                    string tipo = tabla.Columns[campo].DataType.ToString();
                    if (tipo.Contains("String")) vista.RowFilter = "[" + campo + "] Like '%" + txtBusqueda.Text + "%'";
                    else vista.RowFilter = "[" + campo + "] Like '%" + txtBusqueda.Text + "%'";
                    this.lblItems.Text = gvproducto.Rows.Count.ToString();
                }
                else
                {
                    vista.RowFilter = "";
                    this.lblItems.Text = gvproducto.Rows.Count.ToString();
                }
            }
        }
        private void txtBusqueda_TextChanged(object sender, EventArgs e)
        {
            buscar();
        }
        private void gvproducto_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey) txtBusqueda.Focus();
            else if (e.KeyCode == Keys.Left) tvwcabezera.Focus();
        }
        private void txtBusqueda_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                gvproducto.Focus();
            }
            else
                e.Handled = false;
        }
        private void tvwcabezera_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Right) gvproducto.Focus();
        }
        public void calcularImporteTablaOrden()
        {
            int totalFilas =gvlista.RowCount;
            decimal cant = 0;
            decimal precioUnit = 0;
            decimal importe = 0;
            if (gvlista.SelectedCells.Count > 0)
            {
                for (int i = 0; i < totalFilas; i++)
                {

                    cant = Convert.ToDecimal(gvlista.Rows[i].Cells[4].Value);//1
                    precioUnit = Convert.ToDecimal(gvlista.Rows[i].Cells[3].Value);//3.50
                    importe = (precioUnit * cant);//350
                    gvlista.Rows[i].Cells[5].Value = importe.ToString("N2");
                }
            }
        }
        public void sumarTotal()
        {
            double total = 0;
            int totalFilas = gvlista.RowCount;
            if (totalFilas >= -1)
            {
                for (int i = 0; i < totalFilas; i++)
                {
                    double importe = 0;
                    importe = double.Parse(Convert.ToString(gvlista.Rows[i].Cells[5].Value));
                    total = total + importe;
                }
                lbltotal.Text = total.ToString("N2");
            }
        }  
        private void gvproducto_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (gvproducto.SelectedCells.Count > 0 && e.RowIndex != -1 && e.ColumnIndex != -1)
            {
                int fila = e.RowIndex;
                int columna = e.ColumnIndex;
                String idDetalle = "0";
                String codigoProducto = "";
                codigoProducto = Convert.ToString(gvproducto.Rows[fila].Cells[0].Value);
                String xdescripcion = "";
                xdescripcion = Convert.ToString(gvproducto.Rows[fila].Cells[1].Value);
                String xprecio = "";
                xprecio = Convert.ToString(gvproducto.Rows[fila].Cells[2].Value);
                String tipo = "";
                tipo = Convert.ToString(gvproducto.Rows[fila].Cells[3].Value);
                String stock = "";
                stock = Convert.ToString(gvproducto.Rows[fila].Cells[4].Value);
                String xCosto = ""; 
                xCosto=Convert.ToString(gvproducto.Rows[fila].Cells[5].Value);
                String xEnviar = "";
                xEnviar= Convert.ToString(gvproducto.Rows[fila].Cells[6].Value);
                int totalFilas = 0;
                totalFilas = gvlista.RowCount;
                String codigoProd = string.Empty;
                for (int i = 0; i < totalFilas; i++)
                {
                    codigoProd = Convert.ToString(gvlista.Rows[i].Cells[1].Value);
                    if (codigoProducto.Equals(codigoProd)) { MessageBox.Show("EL PRODUCTO YA FUÉ SELECCIONADO", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning); return; }
                }
                gvlista.Rows.Add(idDetalle, codigoProducto, xdescripcion, xprecio, 1, xprecio,xCosto,xprecio,0,"PENDIENTE",xEnviar);
                calcularImporteTablaOrden();
                sumarTotal();
                lblItemB.Text = gvlista.Rows.Count.ToString();
            }
        }
        private void btnagregar_Click(object sender, EventArgs e)
        {
            if (filaSeleccionada == -1) 
            {
                men.SeleccioneUnDato();
            }
            else
            {
                double cant =double.Parse(txtCantidad.Text);
                cant = cant + 1;
                txtCantidad.Text = cant.ToString();
                gvlista.Rows[filaSeleccionada].Cells[4].Value = cant.ToString("N2");
                double precioUnit = 0;
                precioUnit = double.Parse(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[3].Value));
                double importe = 0;
                if (!string.IsNullOrEmpty(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[11].Value)))
                {
                    double xcantA = 0;
                    double xdiferencia = 0;
                    xcantA = double.Parse(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[11].Value));
                    xdiferencia = cant - xcantA;
                    gvlista.Rows[filaSeleccionada].Cells[12].Value = xdiferencia.ToString();
                }
                importe = (precioUnit * cant);
                gvlista.Rows[filaSeleccionada].Cells[5].Value = importe.ToString("N2");
                sumarTotal();
            }
        }
        private void gvlista_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            if (gvlista.CurrentCell.ColumnIndex == 3 ||gvlista.CurrentCell.ColumnIndex == 4)
            {
                TextBox texto = e.Control as TextBox;
                if (texto != null)
                {
                    texto.KeyPress -= new KeyPressEventHandler(dgv);
                    texto.KeyPress += new KeyPressEventHandler(dgv);
                }
            }
        }
        private void gvlista_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            filaSeleccionada = -1;
            filaSeleccionada = e.RowIndex;
            if (gvlista.SelectedCells.Count > 0 && filaSeleccionada > -1)
            {
                double cant = 0;
                cant = Convert.ToDouble(gvlista.Rows[filaSeleccionada].Cells[4].Value);
                txtCantidad.Text = cant.ToString();
            }
        }
        private void btnrestar_Click(object sender, EventArgs e)
        {
            if (filaSeleccionada == -1) 
            {
                men.SeleccioneUnDato();
            }
            else
            {
                double cant =double.Parse(txtCantidad.Text);
                if (cant == 1) { cant = 1; }
                else
                {
                    cant = cant - 1;
                }
                txtCantidad.Text = cant.ToString();
                gvlista.Rows[filaSeleccionada].Cells[4].Value = cant.ToString("N2");
                double precioUnit = 0;
                precioUnit = double.Parse(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[3].Value));
                if (!string.IsNullOrEmpty(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[11].Value)))
                {
                    double xcantA = 0;
                    double xdiferencia = 0;
                    xcantA = double.Parse(Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[11].Value));
                    xdiferencia = cant - xcantA;
                    gvlista.Rows[filaSeleccionada].Cells[12].Value = xdiferencia.ToString();
                }
                double importe = 0;
                importe = (precioUnit * cant);
                gvlista.Rows[filaSeleccionada].Cells[5].Value = importe.ToString("N2");
                sumarTotal();
            }
        }
        public void eliminarFila()
        {
            if (gvlista.SelectedCells.Count > 0)
            {
                string xid = string.Empty;
                xid=Convert.ToString(gvlista.CurrentRow.Cells[0].Value);
                if (codigoOrdenLocal.Equals(""))
                {
                    gvlista.Rows.RemoveAt(gvlista.CurrentRow.Index);
                    int totalFilas = gvlista.RowCount;
                    if (totalFilas == 0)
                    {
                        lbltotal.Text = "0.00";
                        txtCantidad.Text = "0";
                    }
                    else
                    {
                        sumarTotal();
                        txtCantidad.Text = "0";
                        lblItemB.Text = gvlista.Rows.Count.ToString();
                    }
                    xid = string.Empty;
                }
                else
                {
                    if (gvlista.Rows.Count <= 1)
                    {
                        MessageBox.Show("No puede eliminar toda la lista del detalle o de lo contrario anule la orden", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        gvlista.Focus();
                    }
                    else
                    {
                        AccesoDatos daSQL = new AccesoDatos("con");
                        string rpt = daSQL.ejecutarComando("uspDetalleEliminarCsv", "@DetalleId",xid);
                        if (rpt == "true")
                        {
                            gvlista.Rows.RemoveAt(gvlista.CurrentRow.Index);
                            sumarTotal();
                            txtCantidad.Text ="0";
                            lblItemB.Text = gvlista.Rows.Count.ToString();
                        }
                        else
                        {
                            men.EliminoError();
                        }
                    }
                }
            }
        }
        private void gvlista_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (gvlista.SelectedCells.Count > 0)
            {
                filaSeleccionada = -1;
                filaSeleccionada = e.RowIndex;
                if (e.ColumnIndex == 13)
                {
                    if (codigoOrdenLocal.Equals(""))
                    {
                        gvlista.Rows.RemoveAt(gvlista.CurrentRow.Index);
                        int totalFilas = gvlista.RowCount;
                        if (totalFilas == 0)
                        {
                            lbltotal.Text = "0.00";
                            txtCantidad.Text = "0";
                            filaSeleccionada = -1;
                        }
                        else
                        {
                            sumarTotal();
                            txtCantidad.Text = "0";
                            filaSeleccionada = -1;
                            lblItemB.Text = gvlista.Rows.Count.ToString();
                        }
                    }
                    else
                    {
                        if (gvlista.Rows.Count <= 1)
                        {
                            MessageBox.Show("No puede eliminar toda la lista del detalle o de lo contrario anule la orden", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            gvlista.Focus();
                        }
                        else
                        {
                            string idDetalleEliminar = "";
                            idDetalleEliminar = Convert.ToString(gvlista.Rows[filaSeleccionada].Cells[0].Value);
                            AccesoDatos daSQL = new AccesoDatos("con");
                            string rpt = daSQL.ejecutarComando("uspDetalleEliminarCsv", "@DetalleId", idDetalleEliminar);
                            if (rpt == "true")
                            {
                                gvlista.Rows.RemoveAt(gvlista.CurrentRow.Index);
                                sumarTotal();
                                txtCantidad.Text = "0";
                                filaSeleccionada = -1;
                                lblItemB.Text = gvlista.Rows.Count.ToString();
                            }
                            else
                            {
                                men.EliminoError();
                            }
                        }
                    }
                }
            }
        }
        private void txtObservacion_TextChanged(object sender, EventArgs e)
        {
            txtObservacion.CharacterCasing = CharacterCasing.Upper;
        }
        private void gvlista_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            double precioUnit = 0;
            try
            {
                double xcant = 0;
                double importe = 0;
                if (gvlista.CurrentCell.ColumnIndex == 4)
                {
                    if (gvlista.CurrentRow.Cells[4].Value == null || Convert.ToString(gvlista.CurrentRow.Cells[4].Value) == "" || Convert.ToDecimal(gvlista.CurrentRow.Cells[4].Value) == 0)
                    {
                        precioUnit = Convert.ToDouble(gvlista.CurrentRow.Cells[3].Value);
                        gvlista.CurrentRow.Cells[4].Value = "1.00";
                        gvlista.CurrentRow.Cells[5].Value = precioUnit.ToString("N2");
                        if (!string.IsNullOrEmpty(Convert.ToString(gvlista.CurrentRow.Cells[11].Value)))
                        {
                            double xcantA = 0;
                            double xdiferencia = 0;
                            xcantA = double.Parse(Convert.ToString(gvlista.CurrentRow.Cells[11].Value));
                            xdiferencia =1- xcantA;
                            gvlista.CurrentRow.Cells[12].Value = xdiferencia.ToString();
                        }
                        sumarTotal();
                    }
                    else if (Convert.ToDecimal(gvlista.CurrentRow.Cells[4].Value) != 0)
                    {
                        precioUnit = Convert.ToDouble(gvlista.CurrentRow.Cells[3].Value);
                        xcant = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value);
                        importe = (precioUnit * xcant);
                        gvlista.CurrentRow.Cells[4].Value = xcant.ToString("N2");
                        gvlista.CurrentRow.Cells[5].Value = importe.ToString("N2");
                        if (!string.IsNullOrEmpty(Convert.ToString(gvlista.CurrentRow.Cells[11].Value)))
                        {
                            double xcantA = 0;
                            double xdiferencia = 0;
                            xcantA = double.Parse(Convert.ToString(gvlista.CurrentRow.Cells[11].Value));
                            xdiferencia = xcant - xcantA;
                            gvlista.CurrentRow.Cells[12].Value = xdiferencia.ToString();
                        }
                        sumarTotal();
                    }
                }
                else if (gvlista.CurrentCell.ColumnIndex == 3)
                {
                    if (gvlista.CurrentRow.Cells[3].Value == null || Convert.ToString(gvlista.CurrentRow.Cells[3].Value) == "" || Convert.ToDecimal(gvlista.CurrentRow.Cells[3].Value) == 0)
                    {
                        precioUnit = Convert.ToDouble(gvlista.CurrentRow.Cells[7].Value);
                        gvlista.CurrentRow.Cells[3].Value = precioUnit;
                        xcant = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value);
                        importe = (precioUnit * xcant);
                        gvlista.CurrentRow.Cells[5].Value = importe.ToString("N2");
                        sumarTotal();
                    }
                    else if (Convert.ToDecimal(gvlista.CurrentRow.Cells[3].Value) != 0)
                    {
                        if (Convert.ToDecimal(gvlista.CurrentRow.Cells[3].Value) < Convert.ToDecimal(gvlista.CurrentRow.Cells[6].Value))
                        {
                            MessageBox.Show("El precio unitario esta por muy debajo del precio venta B(Verificar...)", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                            precioUnit = Convert.ToDouble(gvlista.CurrentRow.Cells[7].Value);
                            gvlista.CurrentRow.Cells[3].Value = precioUnit;
                            xcant = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value);
                            importe = (precioUnit * xcant);
                            gvlista.CurrentRow.Cells[5].Value = importe.ToString("N2");
                            sumarTotal();
                        }
                        else
                        {
                            precioUnit = Convert.ToDouble(gvlista.CurrentRow.Cells[3].Value);
                            xcant = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value);
                            importe = (precioUnit * xcant);
                            gvlista.CurrentRow.Cells[3].Value = precioUnit.ToString("N2");
                            gvlista.CurrentRow.Cells[5].Value = importe.ToString("N2");
                            sumarTotal();
                        }
                    }
                }
                filaSeleccionada = -1;
                txtCantidad.Text = "0";
            }
            catch (Exception ex)
            {
                ex.ToString();
                MessageBox.Show("Ingrese Correctamente el Numero", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        public void insertarDatosInOne(int codigoOrden, bool anular, string estadoOrden, string estadoMesa, string estadoDetalle)
        {
            string xdata = string.Empty;
            int totalFilas = gvlista.Rows.Count;
            xdata = codigoOrden + "|1|" + txtSerie.Text + "|" + txtCorrelativo.Text + "|" + txtMesa.Text +
            "|" + txtObservacion.Text + "|" + xPersonal + "|" + decimal.Parse(lbltotal.Text) + "|" + estadoOrden + "|" + estadoMesa + "[";
            for (int i = 0; i < totalFilas; i++)
            {
                if (codigoOrden == 0)
                    xdata += Convert.ToString("0");//IdPedidoDetalle
                else
                    xdata += Convert.ToString(gvlista.Rows[i].Cells[0].Value);//IdPedidoDetalle  
                xdata += "|";
                xdata += Convert.ToString(gvlista.Rows[i].Cells[1].Value);//IdProducto
                xdata += "|";
                xdata += Convert.ToDecimal(gvlista.Rows[i].Cells[4].Value);//Cantidad
                xdata += "|";
                xdata += Convert.ToDecimal(gvlista.Rows[i].Cells[3].Value);//PrecioUnit
                xdata += "|";
                xdata += Convert.ToDecimal(gvlista.Rows[i].Cells[5].Value);//Importe
                xdata += "|";
                xdata += estadoDetalle;
                if (i == totalFilas - 1) break;
                else xdata += ";";
            }
            string idsMesas = "";
            if (!mesas_local.Equals(""))
            {
                string[] mesas = mesas_local.Split(',');
                int cantidadMesas = mesas.Length;
                for (int i = 0; i < cantidadMesas; i++)
                {
                    idsMesas += mesas[i].ToString() + ";";
                }
                string salidaMesa = idsMesas.Substring(0, idsMesas.Length - 1);
                xdata += "[" + salidaMesa;
            }
            else
            {
                xdata += "[" + string.Empty;
            }
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("uspInsertaCabeceraDetalle", "@ListaOrden", xdata);
            if (rpt == "")
            {
                men.ErrorGuardado();
            }
            else
            {
                if (estadoOrden.Equals("REGISTRADO"))
                {
                    imprimirGuia();
                    men.GuardoCorrecto();
                }
                else if (estadoOrden.Equals("CONFIRMADO"))
                {
                    men.EditoCorrecto();
                }
                else if (estadoOrden.Equals("ANULADO"))
                {
                    MessageBox.Show("SE ANULÓ CORRECTAMENTE", "ANULADO", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else if (estadoOrden.Equals("ENVIADO"))
                {
                    MessageBox.Show("Se envio a Caja Correctamente", "COBRO", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                principal.obtenerListaMesa();
                this.Close();
            }
        }
        private void btnguardar_Click(object sender, EventArgs e)
        {
            if(gvlista.Rows.Count<=0)
            {
                MessageBox.Show("Seleccione almenos un Producto para generar una Orden Pedido", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                string estadoMesa = "OCUPADA";
                if (tipoRegistro_local.Equals("RESERVAR"))
                {
                    estadoMesa = "RESERVADA";
                }
                string estadoDetalle = "PENDIENTE";
                insertarDatosInOne(0, false, "REGISTRADO", estadoMesa, estadoDetalle);
            }
        }
        private void btnnuevo_Click(object sender, EventArgs e)
        {
            gvlista.Rows.Clear();
            gvlista.DataSource = null;
            filaSeleccionada = -1;
            txtCantidad.Text = "0";
            lblItemB.Text = "0";
            sumarTotal();
        }
        private void btneditar_Click(object sender, EventArgs e)
        {
            string estadoMesa = string.Empty;
            //if (linkenviar.Text == "Enviar Caja")
            estadoMesa ="OCUPADA";
            //else estadoMesa = "POR SALIR";
            string estadoDetalle = "PENDIENTE";
            insertarDatosInOne(int.Parse(codigoOrdenLocal), false, "REGISTRADO", estadoMesa, estadoDetalle);
        }
        private void btneliminar_Click(object sender, EventArgs e)
        {
            if (btneliminar.Enabled == true)
            {
                DialogResult resul = new DialogResult();
                resul = MessageBox.Show("Esta Seguro Que Desea Anular la Orden De Pedido?", "ELIMINAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                if (resul == DialogResult.OK)
                {
                    string estadoMesa = "LIBRE";
                    string estadoDetalle = "PENDIENTE";
                    insertarDatosInOne(int.Parse(codigoOrdenLocal), true, "ANULADO", estadoMesa, estadoDetalle);
                }
            }
        }
        private void linkenviar_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string estadoMesa = string.Empty;
            string estadoDetalle = string.Empty;
            if (xEstado.Equals("ENVIADO"))
            {
                estadoMesa = "OCUPADA";
                estadoDetalle = "PENDIENTE";
                insertarDatosInOne(int.Parse(codigoOrdenLocal), false, "REGISTRADO", estadoMesa, estadoDetalle);
            }
            else
            {
                estadoMesa = "POR SALIR";
                estadoDetalle = "PENDIENTE";
                insertarDatosInOne(int.Parse(codigoOrdenLocal), false, "ENVIADO", estadoMesa, estadoDetalle);
            }
        }
        private void btnConfiguracionMesas_MouseLeave(object sender, EventArgs e)
        {
            btnConfiguracionMesas.BackColor = Color.FromArgb(255, 128, 0);
        }
        private void btnConfiguracionMesas_MouseMove(object sender, MouseEventArgs e)
        {
            btnConfiguracionMesas.BackColor = Color.Blue;
        }
        public void traerMesasDelPedido()
        {
            string[] listaMesas;
            int nroRegistros;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarConsulta("select isnull((select STUFF((select '¬'+ convert(varchar,id_mesa) "+
            "From Combinacion_Mesas where IdOrden='"+codigoOrdenLocal+"'FOR XML PATH('')),1,1,'')),'~') AS RESULT");
            if (rpt != "~")
            {
                listaMesas = rpt.Split('¬');
                nroRegistros = listaMesas.Length;
                List<EGeneral> mesas = new List<EGeneral>();
                string dpt;
                mesas.Add(new EGeneral() { Codigo = "", Nombre = "Seleccione" });
                for (int i = 0; i < nroRegistros; i++)
                {
                    dpt = listaMesas[i];
                    mesas.Add(new EGeneral() { Codigo = dpt, Nombre = "MESA " + dpt });
                }
                comboBox2.DataSource = mesas;
                comboBox2.DisplayMember = "Nombre";
                comboBox2.ValueMember = "Codigo";
            }
        }
        public void listarMesasLibres()
        {
            string[] listaMesas;
            int nroRegistros;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarConsulta("select isnull((select STUFF((select '¬'+ convert(varchar,id_mesa) " +
            "From tbl_mesa where estado='LIBRE' FOR XML PATH('')),1,1,'')),'~') AS RESULT");
            if (rpt != "~")
            {
                listaMesas = rpt.Split('¬');
                nroRegistros = listaMesas.Length;
                List<EGeneral> mesas = new List<EGeneral>();
                string dpt;
                mesas.Add(new EGeneral() { Codigo = "", Nombre = "Seleccione" });
                for (int i = 0; i < nroRegistros; i++)
                {
                    dpt = listaMesas[i];
                    mesas.Add(new EGeneral() { Codigo = dpt, Nombre = "MESA " + dpt });
                }
                comboBox1.DataSource = mesas;
                comboBox1.DisplayMember = "Nombre";
                comboBox1.ValueMember = "Codigo";
            }
        }
        private void btnConfiguracionMesas_Click(object sender, EventArgs e)
        {
            //Tamaño para el campo txtMesas
            btnA.Visible = true;
            btnQuitar.Visible = true;
            comboBox1.Visible = true;
            comboBox2.Visible = true;
            //Agregar
            comboBox1.Text = "";
            //Eliminar
            comboBox2.Text = "";
            traerMesasDelPedido();
            listarMesasLibres();
        }
        private void btnA_Click(object sender, EventArgs e)
        {
            if (!comboBox1.Text.Equals("Seleccione"))
            {
                string codigoMesaAgregar = comboBox1.Text.Replace("MESA ", "");
                string salidaMesaUpdate = string.Empty;
                if (!mesas_local.Equals(""))
                {
                    string textMesas = "";
                    string[] mesas = mesas_local.Split(',');
                    int cantidadMesas = mesas.Length;
                    for (int i = 0; i < cantidadMesas; i++)
                    {
                        textMesas += mesas[i].ToString() + ",";
                    }
                    salidaMesaUpdate = textMesas.Substring(0, textMesas.Length - 1);
                    salidaMesaUpdate += "," + codigoMesaAgregar;
                }
                string xdata = codigoOrdenLocal + "|" + codigoMesaAgregar + "|" + "0" + "|" + salidaMesaUpdate;
                AccesoDatos daSQL = new AccesoDatos("con");
                string rpt = daSQL.ejecutarComando("upsAgregarEliminarMesas", "@Data", xdata);
                if (rpt != "")
                {
                    MessageBox.Show("LA MESA FUE AGREGADA", "CORRECTO", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    string[] xvalues = rpt.Split('¬');
                    mesas_local = xvalues[0].ToString();
                    txtMesa.Text = xvalues[1].ToString();
                    traerMesasDelPedido();
                    listarMesasLibres();
                    this.principal.obtenerListaMesa();
                }
                else
                {
                    MessageBox.Show("ERROR AGREGANDO LA MESA", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
        }
        private void btnQuitar_Click(object sender, EventArgs e)
        {
            if (!comboBox2.Text.Equals("Seleccione"))
            {
                string codigoMesaEliminar = comboBox2.Text.Replace("MESA ", "");
                string salidaMesaUpdate = string.Empty;
                if (!mesas_local.Equals(""))
                {
                    string textMesas = "";
                    string[] mesas = mesas_local.Split(',');
                    int cantidadMesas = mesas.Length;
                    if (cantidadMesas <= 1)
                    {
                        MessageBox.Show("Solo puedes eliminar cuando hay mas de una mesa... ", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        txtMesa.Focus();
                    }
                    else
                    {
                        for (int i = 0; i < cantidadMesas; i++)
                        {
                            textMesas += mesas[i].ToString() + ",";
                        }
                        salidaMesaUpdate = textMesas.Substring(0, textMesas.Length - 1);
                        salidaMesaUpdate = salidaMesaUpdate.Replace(codigoMesaEliminar, "").Replace(",,", ",");
                        if (salidaMesaUpdate.EndsWith(","))
                        {
                            salidaMesaUpdate = salidaMesaUpdate.Substring(0, salidaMesaUpdate.Length - 1);
                        }
                        string xdata = codigoOrdenLocal + "|" + codigoMesaEliminar + "|" + "1" + "|" + salidaMesaUpdate;
                        AccesoDatos daSQL = new AccesoDatos("con");
                        string rpt = daSQL.ejecutarComando("upsAgregarEliminarMesas", "@Data", xdata);
                        if (rpt != "")
                        {
                            MessageBox.Show("LA MESA ELIMINADA", "CORRECTO", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            string[] xvalues = rpt.Split('¬');
                            mesas_local = xvalues[0].ToString();
                            txtMesa.Text = xvalues[1].ToString();
                            traerMesasDelPedido();
                            listarMesasLibres();
                            this.principal.obtenerListaMesa();
                        }
                        else
                        {
                            MessageBox.Show("ERROR ELIMINANDO LA MESA", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                    }
                }
            }
        }
        private void gvlista_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete) eliminarFila();
        }
        private void gvproducto_ColumnAdded(object sender, DataGridViewColumnEventArgs e)
        {
            gvproducto.Columns[e.Column.Index].SortMode = DataGridViewColumnSortMode.NotSortable;
        }
        public void traer()
        {
            DataTable datos = obj.traerProducto(this.txtcodigo.Text);
            if (txtcodigo.Text.Length == 0)
            {
                men.datosVacios();
            }
            else
            {
                if (datos.Rows.Count == 0)
                {
                    men.codigoError();
                    txtcodigo.Text = "";
                    txtcodigo.Focus();
                }
                else
                {
                    string xid = datos.Rows[0][0].ToString();
                    DataGridViewRow row = gvlista.Rows.Cast<DataGridViewRow>().FirstOrDefault(x => Convert.ToString(x.Cells[1].Value) == xid);
                    if (row != null)
                    {
                        MessageBox.Show("EL PRODUCTO YA FUÉ SELECCIONADO", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                    else
                    {
                        string xdescripcion = "";
                        xdescripcion=datos.Rows[0][3].ToString();
                        string xprecio = "";
                        xprecio= datos.Rows[0][6].ToString();
                        string xcosto = "";
                        xcosto=datos.Rows[0][8].ToString();
                        gvlista.Rows.Add("0",xid, xdescripcion,xprecio, 1, xprecio, xcosto, xprecio, 0, "PENDIENTE","1");
                        calcularImporteTablaOrden();
                        sumarTotal();
                        lblItemB.Text = gvlista.Rows.Count.ToString();
                        txtcodigo.Text = "";
                        txtcodigo.Focus();
                    }
                }
            }
        }
        private void txtcodigo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                if (btnguardar.Enabled == true)
                {
                    if (txtcodigo.Text.Length == 0) gvlista.Focus();
                    else traer();
                }
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txtcodigo_TextChanged(object sender, EventArgs e)
        {
            txtcodigo.CharacterCasing = CharacterCasing.Upper;
        }

        private void gvlista_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
