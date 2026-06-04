using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
//using System.Text;
using System.Drawing.Printing;
using System.Data.SqlClient;
using System.Runtime.InteropServices;
using MegaRosita.Capa.Logica;
using MegaRosita.Capa.Entidades;
using MegaRosita.Capa.Datos;
using MegaRosita.Capa.Comun;
using MegaRosita.Capa.Conexion;
using System.Windows.Forms;
//using System.Net.WebSockets;
//using System.Threading;
//using System.Threading.Tasks;
//using Microsoft.VisualBasic;
using System.Diagnostics;
using ZXing;
//using System.IO;
//using TEXTO = iTextSharp.text;
//using PDFX = iTextSharp.text.pdf;
using TEXTO = iTextSharp.text;
using PDFX = iTextSharp.text.pdf;
using System.IO;
namespace MegaRosita.Capa.Aplicacion
{
    public partial class FrmNotaPedido : Form
    {
        LogProducto obj = new LogProducto();
        Mensajes men = new Mensajes();
        LogCliente objcliente = new LogCliente();
        EDetalleNota detalle = new EDetalleNota();
        LogPedidos objpedido = new LogPedidos();
        List<ElistaNota> objeto;
        List<EListaProducto> objetopro;
        ETemporalVenta temporal = new ETemporalVenta();
        LogTempoVenta objtemporal = new LogTempoVenta();
        List<TextBox> tList = new List<TextBox>();
        List<string> sList = new List<string>();
        List<EGeneral> listaGuias;
        private DataTable Tabla;
        BindingSource bs;
        private DataView vista;
        string[] listas;
        //ClientWebSocket cliente;
        public string xUsuario { get; set; }
        public string xidUsuario { get; set; }
        public string xCompania { get; set; }
        public string xArea { get; set; }
        public string xRuc { get; set; }
        public string xIdCompania { get; set; }
        public string xSerieBoleta { get; set; }
        public string xEnvioBoleta { get; set; }
        public string xEnvioFactura { get; set; }
        public string xComercial { get; set;}
        private string xPersonal = string.Empty;
        public string xCopia=string.Empty;
        private DataTable TablaT;
        BindingSource bsT;
        private DataView vistaT;
        int xAvisoPrint = 0;
        //=====================
        public double xIGV { get; set; }
        public double xIGVD { get; set; }
        public double xIMP_BOLSA { get; set; }
        public string xSUB_FIJO { get; set; }
        public string xDES_FIJO { get; set; }
        public double xDescuentoMax { get; set; }
        //=======pdf boleta====
        float tableHeight = 0;
        string filename = string.Empty;
        //=====================
        public FrmNotaPedido()
        {
            InitializeComponent();
            xDescuentoMax = 5;
            cmdentrega.Text = "INMEDIATA";
            lblserie.Text = "";
            lblidclien.Text = "1";
            lblvendedor.Text = "";
            lblfechaMod.Text = "";
            lblmodifica.Text = "";
            lblestado.Text = "";
            lblemitido.Text = "";
            cmdcondicion.Text = "ALCONTADO";
            cmdforma.Text = "EFECTIVO";
            cmdconcepto.Text = "MERCADERIA";
            tList.Add(txtmovilidad);
            sList.Add("0.00");
            tList.Add(txtdescuento);
            sList.Add("0.00");
            tList.Add(txtacuenta);
            sList.Add("0.00");
            SetCueBanner(ref tList, sList);
            SetCueBanner(ref tList, sList);
            SetCueBanner(ref tList, sList);
            this.metroTabControl1.SelectedIndex = 0;
        }
        #region Inicial
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
        private static extern IntPtr SendMessage(IntPtr hWnd, uint msg, IntPtr i, string str);
        void SetCueBanner(ref List<TextBox> textBox, List<string> CueText)
        {
            for (int x = 0; x < textBox.Count; x++)
            {
                SendMessage(textBox[x].Handle, 0x1501, (IntPtr)1, CueText[x]);
            }
        }
        public void Gestion()
        {
            if (xArea != "GERENCIA Y ADMINISTRACION")
            {
                this.cmdcompania.Enabled = false;
                this.lblefectivo.Visible = false;
                this.lbltarjeta.Visible = false;
                this.lbltotalB.Visible = false;
                this.lblA.Visible = false;
                this.lblB.Visible = false;
                this.lblC.Visible = false;
                this.lbltexto.Visible = false;
                this.lblganancia.Visible = false;
                this.linkdetalle.Visible = false;
            } 
        }
        #region MetodosGuias
        #endregion
        public void cargarload()
        {
            this.Text = ".:.Bienvenido(a) " + xUsuario.ToString();
            xIGVD = (xIGV / 100) + 1;
            cargarComboTipoComprobante();
            cargarConcepto();
            men.alternarcolor(gvlista);
            Gestion();
            txtvendedor.Text = xUsuario;
            cmdcompania.Text = xCompania;
            listar();
            listarDetalle();
            txtcliente.AutoCompleteCustomSource = AutoCompleClass.Autocomplete();
            txtruc.AutoCompleteCustomSource = AutoCompleClass.AutocompleteRUCCliente();
            txtdni.AutoCompleteCustomSource = AutoCompleClass.AutocompleteDNI();
            cmddocumento.Text = "BOLETA";
            cmdfiltrar.Text = "CLIENTE";
            txtcodigo.Focus();
        }
        public void cargarMesas()
        {
            cmdMesas.DataSource = AutoCompleClass.DatosMesas();
            cmdMesas.DisplayMember = "Mesas";
            cmdMesas.ValueMember = "ID";
            if (btnguardar.Enabled == true)
            {
                if (cmdMesas.Items.Count <= 0) cmdMesas.Enabled = false;
                else cmdMesas.Enabled = true;
            }
        }
        public void cargarComboTipoComprobante()
        {
            DataTable dt;
            dt = new DataTable("Tabla");
            dt.Columns.Add("Codigo");
            dt.Columns.Add("Descripcion");
            DataRow dr;
            dr = dt.NewRow();
            dr["Codigo"] = "01";
            dr["Descripcion"] = "FACTURA";
            dt.Rows.Add(dr);
            dr = dt.NewRow();
            dr["Codigo"] = "03";
            dr["Descripcion"] = "BOLETA";
            dt.Rows.Add(dr);
            dr = dt.NewRow();
            dr["Codigo"] = "00";
            dr["Descripcion"] = "PROFORMA V";
            dt.Rows.Add(dr);
            cmddocumento.ComboBox.DataSource = dt;
            cmddocumento.ComboBox.ValueMember = "Codigo";
            cmddocumento.ComboBox.DisplayMember = "Descripcion";
        }
        public void cargarConcepto()
        {
            DataTable dt;
            dt = new DataTable("Tabla");
            dt.Columns.Add("Codigo");
            dt.Columns.Add("Descripcion");
            DataRow dr;
            dr = dt.NewRow();
            dr["Codigo"] = "1";
            dr["Descripcion"] = "MERCADERIA";
            dt.Rows.Add(dr);
            dr = dt.NewRow();
            dr["Codigo"] = "2";
            dr["Descripcion"] = "SERVICIO";
            dt.Rows.Add(dr);
            dr = dt.NewRow();
            if (!xArea.Contains("VENTAS"))
            {
                dr["Codigo"] = "3";
                dr["Descripcion"] = "CONTINGENCIA";
                dt.Rows.Add(dr);
                dr = dt.NewRow();
            }
            cmdconcepto.ComboBox.DataSource = dt;
            cmdconcepto.ComboBox.ValueMember = "Codigo";
            cmdconcepto.ComboBox.DisplayMember = "Descripcion";
        }
        #endregion
        #region MetodosGlobales
        public void limpiar()
        {
            if (btnguardar.Enabled == true)
            {
                if (gvlista.Rows.Count >= 1) eliminarTodo();
            }
            cargarMesas();
            this.lblidMesa.Text = "0";
            txtcodigo.Enabled =true;
            chkbuscar.Enabled = true;
            xCopia = string.Empty;
            xPersonal = string.Empty;
            xAvisoPrint = 0;
            txtmovilidad.Text = "";
            txtdescuento.Text = "";
            txtefectivo.Text = "";
            lblvuelto.Text = "0.00";
            cmdconcepto.Text = "MERCADERIA";
            lblidnota.Text = "";
            txtnrodoc.Text = "00000001";
            lblfechaMod.Text = "";
            cmddocumento.Text = "BOLETA";
            cmdcondicion.Text = "ALCONTADO";
            cmdforma.Text = "EFECTIVO";
            cmdentrega.Text = "INMEDIATA";
            detimepago.Text = DateTime.Now.ToString("dd/MM/yyyy");
            cmdsublinea.Text = "TODOS";
            lblidclien.Text = "1";
            lblmodifica.Text = "";
            lblvendedor.Text = "";
            lblestado.Text = "";
            lblemitido.Text = "";
            txtcliente.Text = "PUBLICO GENERAL";
            txtruc.Text = "";
            txtdni.Text = "";
            txtfiscal.Text = "";
            txtdespacho.Text = "";
            txttelefono.Text = "";
            txtcodigo.Text = "";
            lblitems.Text = "0";
            lblsubtotal.Text = "0.00";       
            lbltotal.Text = "0.00";
            txtacuenta.Text = "";
            lblsaldo.Text = "0.00";
            lbladicional.Text = "0.00";
            lbltotalTarjeta.Text = "0.00";
            lbltotalpagar.Text = "0.00";
            lblmtc.Text = "0.00";
            lblporcentaje.Text = "Adic. 0.0%:";
            listaRe.Items.Clear();
            listaReB.DataSource = null;
            activarCajas();
            cmdconcepto.Enabled = true;
            btnguardar.Enabled = true;
            btneditar.Enabled = false;
            btnactivar.Enabled = false;
            btneliminar.Enabled = false;
            btncopia.Enabled = false;
            btnimprimir.Enabled = true;
            lbldesci.Text = "Codigo:";
            listarDetalle();
            cmdcompania.Text = xCompania;
            chkbuscar.Checked = false;
            this.metroTabControl1.SelectedIndex = 0;
            chkLlevar.Checked =false;
            cmdMesas.Visible = true;
            lbltextoB.Visible = true;
            chkbuscar.Checked = false;
            chkbuscar.Enabled = false;
            txtcodigo.Enabled = false;
            cmdsublinea.Visible = false;
            lbltextoA.Visible = false;
            txtcodigo.Text = "";
            txtcodigo.Focus();
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
        #endregion
        #region ImprimirBoleta
        public void imprimirBoletas()
        {
            exportarBoleta();
            try
            {
                if (conexion.ClienteFE.Contains("R"))
                {
                    RawPrinterHelper.SendStringToPrinter(conexion.predeterminado(), Convert.ToString((char)27) + Convert.ToString((char)112) + Convert.ToString((char)0) + Convert.ToString((char)25) + Convert.ToString((char)250));
                }
                PaperSize pageSize;
                pageSize = new PaperSize("ILIMITADO", 80, 3276);
                PrintDocument formulario = new PrintDocument();
                formulario.PrintController = new StandardPrintController();
                formulario.PrintPage += new PrintPageEventHandler(impresionBE);
                formulario.PrinterSettings.PrinterName = conexion.predeterminado();
                formulario.Print();
                ////visualizar la impresion
                //PrintPreviewDialog printPreviewDialog1 = new PrintPreviewDialog();
                //printPreviewDialog1.Document = formulario;
                //printPreviewDialog1.ShowDialog();
            }
            catch (Exception ex)
            {
                men.impresoraError();
                ex.ToString();
            }
        }
        public void imprimir()
        {
            try
            {
                if (xCopia != "Copia")
                {
                    RawPrinterHelper.SendStringToPrinter(conexion.predeterminado(), Convert.ToString((char)27) + Convert.ToString((char)112) + Convert.ToString((char)0) + Convert.ToString((char)25) + Convert.ToString((char)250));
                }
                PaperSize pageSize;
                pageSize = new PaperSize("ILIMITADO", 80, 3276);
                PrintDocument formulario = new PrintDocument();
                formulario.PrintController = new StandardPrintController();
                formulario.PrintPage += new PrintPageEventHandler(datoscliente);
                formulario.PrinterSettings.PrinterName = conexion.predeterminado();
                formulario.Print();
                //visualizar la impresion
                //PrintPreviewDialog printPreviewDialog1 = new PrintPreviewDialog();
                //printPreviewDialog1.Document = formulario;
                //printPreviewDialog1.ShowDialog();
            }
            catch (Exception ex)
            {
                men.impresoraError();
                ex.ToString();
            }
        }
        #endregion
        #region ImprimirLaptos
        public void datoscliente(object obj, PrintPageEventArgs ev)
        {
            descuentos();
            Font fuente = new Font("Arial", 8);
            Font fuente3 = new Font("Arial", 10);
            Font fuente2 = new Font("Arial", 8, FontStyle.Bold);
            Font fuente4 = new Font("Arial", 10, FontStyle.Bold);
            float pos_x = 0;
            float pos_y = 0;
            string idboleta, cdocumento, fecha, cliente, despacho, celular, vendedor, vsubtotal, voperacion,
            vadicional, vtotal, numero, sdescuento, smovilidad, sdireccion, stelefono, formapago;
            double vmovilidad, vdescuento;
            sdireccion = conexion.xDireccion;
            stelefono = conexion.xTelefono;
            idboleta = "N°ro Docu:    " + lblidnota.Text;
            cdocumento = "Documento:  PROFORMA V";
            fecha = "Fecha Emision: " + DateTime.Now.ToString("dd/MM/yyyy  HH:mm:ss");
            formapago = "Forma Pago: " + cmdforma.Text;
            cliente = "Cliente: " + txtcliente.Text;
            despacho = "Direccion: " + txtdespacho.Text;
            celular = "Telefono: " + txttelefono.Text;
            if (xCopia == string.Empty)
                vendedor = "Vendedor: " + xPersonal.ToString();
            else
                vendedor = "Atendido Por: " + lblvendedor.Text;
            numero = lblitems.Text;
            vsubtotal = lblsubtotal.Text;
            if (txtmovilidad.Text.Length == 0)
                vmovilidad = 0;
            else
                vmovilidad = double.Parse(txtmovilidad.Text);
            if (txtdescuento.Text.Length == 0)
                vdescuento = 0;
            else
                vdescuento = double.Parse(txtdescuento.Text);
            voperacion = lbltotal.Text;
            vadicional = lbladicional.Text;
            vtotal = lbltotalpagar.Text;
            smovilidad = vmovilidad.ToString("N2");
            sdescuento = vdescuento.ToString("N2");
            vsubtotal = FormatearMonto(vsubtotal);
            smovilidad = FormatearMonto(smovilidad);
            sdescuento = FormatearMonto(sdescuento);
            voperacion = FormatearMonto(voperacion);
            vadicional = FormatearMonto(vadicional);
            vtotal = FormatearMonto(vtotal);
            pos_y = 0;
            pos_x =70;
            ev.Graphics.DrawString(conexion.xNombreComercial, fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
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
            ev.Graphics.DrawString(cdocumento, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString(formapago, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString(idboleta, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString(fecha, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            int maxCliente = 46;
            string textosCliente = cliente;
            if (textosCliente.Length > maxCliente)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosCliente.Length; longitudTexto > maxCliente; longitudTexto -= maxCliente)
                {
                    ev.Graphics.DrawString(textosCliente.Substring(caracterActual, maxCliente), fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxCliente;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosCliente.Substring(caracterActual, textosCliente.Length - caracterActual), fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosCliente, fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 17;
            pos_x = 0;
            int maxdireccion = 46;
            string textosdireccion = despacho;
            if (textosdireccion.Length > maxdireccion)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosdireccion.Length; longitudTexto > maxdireccion; longitudTexto -= maxdireccion)
                {
                    ev.Graphics.DrawString(textosdireccion.Substring(caracterActual, maxdireccion), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxdireccion;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosdireccion.Substring(caracterActual, textosdireccion.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosdireccion, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 17;
            ev.Graphics.DrawString(celular, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            ev.Graphics.DrawString(vendedor, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 15;
            ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            ev.Graphics.DrawString("Cantidad", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 55;
            ev.Graphics.DrawString("Uni", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 80;
            ev.Graphics.DrawString("Descripcion", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 178;
            ev.Graphics.DrawString("P. Uni", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 232;
            ev.Graphics.DrawString("Importe", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 0;
            pos_y = pos_y + 8;
            ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            string textos, zunidad = string.Empty;
            int maxCart = 29;
            double cantidad = 0;
            double precios = 0;
            double importe = 0;
            string scantidad, sprecios, simporte, zprecios, zimporte = string.Empty;
            foreach (DataGridViewRow fila in gvlista.Rows)
            {
                textos = Convert.ToString(fila.Cells[6].Value.ToString());
                zunidad = Convert.ToString(fila.Cells[5].Value.ToString()).Substring(0, 3);
                cantidad = Convert.ToDouble(fila.Cells[4].Value);
                precios = Convert.ToDouble(fila.Cells[8].Value);
                importe = Convert.ToDouble(fila.Cells[9].Value);
                scantidad = cantidad.ToString("N2");
                sprecios = precios.ToString("N2");
                simporte = importe.ToString("N2");
                zprecios = FormatearMonto(sprecios);
                zimporte = FormatearMonto(simporte);
                pos_y = pos_y + 19;
                pos_x = 0;
                ev.Graphics.DrawString(scantidad.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 55;
                ev.Graphics.DrawString(zunidad.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 80;
                if (textos.Length > maxCart)
                {
                    int caracterActual = 0;
                    for (int longitudTexto = textos.Length; longitudTexto > maxCart; longitudTexto -= maxCart)
                    {
                        ev.Graphics.DrawString(textos.Substring(caracterActual, maxCart).ToUpper(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                        caracterActual += maxCart;
                        pos_y = pos_y + 19;
                        pos_x = 0;
                    }
                    ev.Graphics.DrawString(textos.Substring(caracterActual, textos.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                }
                else
                {
                    ev.Graphics.DrawString(textos.ToString().ToUpper(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    pos_y = pos_y + 19;
                }
                pos_x = 168;
                ev.Graphics.DrawString(zprecios.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 222;
                ev.Graphics.DrawString(zimporte.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 0;
                pos_y = pos_y + 8;
                ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 30;
            pos_x = 210;
            ev.Graphics.DrawString(vsubtotal, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 113;
            ev.Graphics.DrawString("Sub Total  S/.", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 0;
            ev.Graphics.DrawString("Items:", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 40;
            ev.Graphics.DrawString(numero, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 21;
            pos_x = 118;
            ev.Graphics.DrawString("Movilidad S/.", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(smovilidad, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 21;
            pos_x = 109;
            ev.Graphics.DrawString("Descuento S/.", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(sdescuento, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 21;
            pos_x = 99;
            ev.Graphics.DrawString("Op Gravada S/.", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(voperacion, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 25;
            pos_x = 100;
            ev.Graphics.DrawString("______________________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 21;
            pos_x = 120;
            ev.Graphics.DrawString(lblporcentaje.Text, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vadicional, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 21;
            pos_x = 86;
            ev.Graphics.DrawString("Total A Pagar S/.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vtotal, fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 50;
            pos_x = 0;
            ev.Graphics.DrawString("Nota:No es comprobante de pago", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 16;
            pos_x = 0;
            ev.Graphics.DrawString("Canjear por Boleta o Factura", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
        }
        public void impresionBE(object obj, PrintPageEventArgs ev)
        {
            Font fuente = new Font("Arial", 8);
            Font fuente3 = new Font("Arial", 10);
            Font fuente2 = new Font("Arial", 8, FontStyle.Bold);
            Font fuente4 = new Font("Arial",10, FontStyle.Bold);
            float pos_x = 0;
            float pos_y = 0;
            string fecha, cliente, fiscal, xdni, vendedor, sdireccion, xruc, xUbigeo,
            stelefono, nroDocumento, vmtc, vsubtotal, vigv, vtotal, vDescuento, vinafecta;
            sdireccion = conexion.xDireccion;
            stelefono = conexion.xTelefono;
            xUbigeo = conexion.xUbigeo;
            xruc = xRuc.ToString();
            nroDocumento = lblserie.Text + "-" + txtnrodoc.Text;
            fecha = "FECHA EMISION: " + detimepago.Text +" "+DateTime.Now.ToString("HH:mm:ss");
            cliente = "SEÑOR(A):            " + txtcliente.Text;
            fiscal = "DIRECCION:         " + txtfiscal.Text;
            xdni = "DOC. IDENT:         " + txtdni.Text;
            if (xCopia == string.Empty) vendedor = "VENDEDOR(A):    " + xPersonal.ToString();
            else vendedor = "VENDEDOR(A):    " + lblvendedor.Text;
            vmtc = FormatearMonto(lblmtc.Text);
            xSUB_FIJO = FormatearMonto(xSUB_FIJO);
            vDescuento = FormatearMonto(xDES_FIJO);
            vsubtotal = FormatearMonto(lblsubsunat.Text);
            vigv = FormatearMonto(lbligv.Text);
            vinafecta = FormatearMonto("0.00");
            vtotal = FormatearMonto(lbltotalpagar.Text);
            pos_y = 25;
            pos_x = 0;
            ev.Graphics.DrawString(conexion.NombreComercialPDF.Trim(), fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 95;
            ev.Graphics.DrawString("R.U.C  " + xruc, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 53;
            ev.Graphics.DrawString(sdireccion.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 100;
            ev.Graphics.DrawString(xUbigeo.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 18;
            pos_x = 102;
            ev.Graphics.DrawString(stelefono.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 55;
            ev.Graphics.DrawString("BOLETA DE VENTA ELECTRONICA", fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 117;
            ev.Graphics.DrawString(nroDocumento, fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 25;
            pos_x = 0;
            ev.Graphics.DrawString(fecha, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString("TIPO MONEDA:    SOLES", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString("FORMA PAGO:      ALCONTADO", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            int maxCliente = 46;
            string textosCliente = cliente;
            if (textosCliente.Length > maxCliente)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosCliente.Length; longitudTexto > maxCliente; longitudTexto -= maxCliente)
                {
                    ev.Graphics.DrawString(textosCliente.Substring(caracterActual, maxCliente), fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxCliente;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosCliente.Substring(caracterActual, textosCliente.Length - caracterActual), fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosCliente, fuente2, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 17;
            pos_x = 0;
            int maxdireccion = 46;
            string textosdireccion = fiscal;
            if (textosdireccion.Length > maxdireccion)
            {
                int caracterActual = 0;
                for (int longitudTexto = textosdireccion.Length; longitudTexto > maxdireccion; longitudTexto -= maxdireccion)
                {
                    ev.Graphics.DrawString(textosdireccion.Substring(caracterActual, maxdireccion), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxdireccion;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textosdireccion.Substring(caracterActual, textosdireccion.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textosdireccion, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 17;
            ev.Graphics.DrawString(xdni, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            ev.Graphics.DrawString(vendedor, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 15;
            ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            ev.Graphics.DrawString("Cantidad", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 55;
            ev.Graphics.DrawString("Uni", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 80;
            ev.Graphics.DrawString("Descripcion", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 178;
            ev.Graphics.DrawString("P. Uni", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 232;
            ev.Graphics.DrawString("Importe", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 0;
            pos_y = pos_y + 8;
            ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            string textos, zunidad = string.Empty;
            int maxCart = 29;
            double cantidad = 0;
            double precios = 0;
            double importe = 0;
            string zprecios, zimporte = string.Empty;
            foreach (DataGridViewRow fila in gvlista.Rows)
            {
                textos = Convert.ToString(fila.Cells[6].Value.ToString());
                zunidad = Convert.ToString(fila.Cells[5].Value.ToString()).Substring(0, 3);
                cantidad = Convert.ToDouble(fila.Cells[4].Value);
                precios = Convert.ToDouble(fila.Cells[8].Value);
                importe = Convert.ToDouble(fila.Cells[9].Value);
                zprecios = FormatearMonto(precios.ToString("N2"));
                zimporte = FormatearMonto(importe.ToString("N2"));
                pos_y = pos_y + 19;
                pos_x = 0;
                ev.Graphics.DrawString(cantidad.ToString("N2"), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 55;
                ev.Graphics.DrawString(zunidad.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 80;
                if (textos.Length > maxCart)
                {
                    int caracterActual = 0;
                    for (int longitudTexto = textos.Length; longitudTexto > maxCart; longitudTexto -= maxCart)
                    {
                        ev.Graphics.DrawString(textos.Substring(caracterActual, maxCart).ToUpper(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                        caracterActual += maxCart;
                        pos_y = pos_y + 19;
                        pos_x = 0;
                    }
                    ev.Graphics.DrawString(textos.Substring(caracterActual, textos.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                }
                else
                {
                    ev.Graphics.DrawString(textos.ToString().ToUpper(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    pos_y = pos_y + 19;
                }
                pos_x = 168;
                ev.Graphics.DrawString(zprecios.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 222;
                ev.Graphics.DrawString(zimporte.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 0;
                pos_y = pos_y + 8;
                ev.Graphics.DrawString("___________________________________________________________", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            if (decimal.Parse(vmtc) != 0)
            {
                pos_y = pos_y + 19;
                pos_x = 55;
                ev.Graphics.DrawString("  MV/CT/DS", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                pos_x = 222;
                ev.Graphics.DrawString(vmtc.ToString(), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("Items: " + lblitems.Text, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("OP GRAVADA.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(xSUB_FIJO, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("DESCUENTO.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vDescuento, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("SUB TOTAL.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vsubtotal, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("I.G.V ("+xIGV.ToString()+".00)%.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vigv, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("ICBPER.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vinafecta, fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("IMPORTE TOTAL.", fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 130;
            ev.Graphics.DrawString("S/", fuente3, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_x = 210;
            ev.Graphics.DrawString(vtotal, fuente4, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 25;
            pos_x = 0;
            ev.Graphics.DrawString("SON:", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 20;
            pos_x = 0;
            string textoletra = txtletras.Text;
            int maxletra = 40;
            if (textoletra.Length > maxletra)
            {
                int caracterActual = 0;
                for (int longitudTexto = textoletra.Length; longitudTexto > maxletra; longitudTexto -= maxletra)
                {
                    ev.Graphics.DrawString(textoletra.Substring(caracterActual, maxletra), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
                    caracterActual += maxletra;
                    pos_y = pos_y + 17;
                    pos_x = 0;
                }
                ev.Graphics.DrawString(textoletra.Substring(caracterActual, textoletra.Length - caracterActual), fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            else
            {
                ev.Graphics.DrawString(textoletra, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            }
            pos_y = pos_y + 22;
            pos_x = 0;
            ev.Graphics.DrawString("Autorizado mediante Resolución de Intendencia SUNAT", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString("N° 032-005-Representación impresa de la Boleta ", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString("Electrónica.Consulta tu Comprobante en:", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            pos_y = pos_y + 17;
            pos_x = 0;
            ev.Graphics.DrawString("-http://e-consulta.sunat.gob.pe/ol-ti-itconsvalicpe/ConsValiCpe.htm", fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
            string xvalorBarra = string.Empty;
            DateTime vfecha;
            vfecha = Convert.ToDateTime(detimepago.Text);
            xvalorBarra = xruc + "|03|" + lblserie.Text + "|" + txtnrodoc.Text + "|" + lbligv.Text + "|" + lbltotalpagar.Text + "|" + vfecha.ToString("yyyy-MM-dd") + "|01|" + txtdni.Text;
            BarcodeWriter br = new BarcodeWriter();
            br.Format = BarcodeFormat.QR_CODE;
            Bitmap bm = new Bitmap(br.Write(xvalorBarra), 180, 180);
            Rectangle destRect = new Rectangle(0, (int)pos_y + 15, 180, 180);
            ev.Graphics.DrawImage(bm, destRect);
            pos_y = pos_y + 20;
            pos_x = 0;
            ev.Graphics.DrawString("ID: " + lblidnota.Text, fuente, Brushes.Black, pos_x, pos_y, new StringFormat());
        }
        #endregion
        #region EliminarDatos
        public void eliminar()
        {
            if (gvlista.Rows.Count <= 0)
            {
                men.SeleccioneUnDato();
            }
            else
            {
                DialogResult resul = new DialogResult();
                resul = MessageBox.Show("Esta Seguro Que Desea eliminar un detalle?", "ELIMINAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                if (resul == DialogResult.OK)
                {
                    temporal.Id = Convert.ToInt32(gvlista.CurrentRow.Cells[0].Value);
                    if (objtemporal.eliminar(temporal)) listarDetalle();
                    else men.EliminoError();
                }
            }
        }
        public void eliminarTodo()
        {
            temporal.UsuarioId = xidUsuario;
            if (objtemporal.eliminarTodo(temporal)) listarDetalle();
            else men.EliminoError();
        }
        public void eliminarB()
        {
            if (gvproducto.Rows.Count <= 0)
            {
                men.SeleccioneUnDato();
            }
            else
            {
                string wid = Convert.ToString(gvproducto.CurrentRow.Cells[0].Value);
                DataGridViewRow row = gvlista.Rows.Cast<DataGridViewRow>().FirstOrDefault(x => Convert.ToString(x.Cells[2].Value) == wid);
                if (row == null)
                {
                    MessageBox.Show("No se puede eliminar el producto seleccionado porque no ha sido agregado a la lista de Ventas", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    DialogResult resul = new DialogResult();
                    resul = MessageBox.Show("Esta Seguro Que Desea eliminar un detalle?", "ELIMINAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                    if (resul == DialogResult.OK)
                    {
                        if (btnguardar.Enabled == true)
                        {
                            temporal.IdProducto = Convert.ToInt32(gvproducto.CurrentRow.Cells[0].Value);
                            temporal.UsuarioId = xidUsuario;
                            if (objtemporal.eliminarB(temporal))
                            {
                                listarDetalle();
                                gvproducto.CurrentRow.Cells[7].Value = "";
                                gvproducto.Focus();
                            }
                            else
                                men.EliminoError();
                        }
                        else
                        {
                            detalle.IdProducto = Convert.ToInt32(gvproducto.CurrentRow.Cells[0].Value);
                            detalle.NotaId = int.Parse(lblidnota.Text);
                            if(objpedido.eliminarC(detalle))
                            {
                                listarB();
                                gvproducto.CurrentRow.Cells[7].Value = "";
                                gvproducto.Focus();
                            }
                            else
                                men.EliminoError();
                        }
                    }
                }
            }
        }
        public void eliminardetalle()
        {
            if (gvlista.Rows.Count <= 1)
            {
                men.eliminarNotodo();
                gvlista.Focus();
            }
            else
            {
                DialogResult resul = new DialogResult();
                resul = MessageBox.Show("Esta Seguro Que Desea eliminar un detalle?", "ELIMINAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                if (resul == DialogResult.OK)
                {
                    double xganancia = 0;
                    xganancia = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value) * (Convert.ToDouble(gvlista.CurrentRow.Cells[8].Value) - Convert.ToDouble(gvlista.CurrentRow.Cells[7].Value));
                    string data = string.Empty;
                    data = Convert.ToString(gvlista.CurrentRow.Cells[0].Value) + "|" + xganancia.ToString();
                    AccesoDatos daSQL = new AccesoDatos("con");
                    string rpt = daSQL.ejecutarComando("eliminaDetaNota", "@Data", data);
                    if (rpt == "true")
                    {
                        int pos = bs.Position;
                        listarB();
                        bs.Position = pos;
                        total();
                        gvlista.Focus();
                    }
                    else
                    {
                        men.EliminoError();
                    }
                }
            }
        }
        #endregion
        
        #region Metodos
        public bool editarItems()
        {
            if (gvlista.Rows.Count <= 0)
            {
                men.datosVacios();
            }
            else
            {
                try
                {
                    bool Escorrecto = false;
                    temporal.Cantidad = Convert.ToDecimal(gvlista.CurrentRow.Cells[4].Value);
                    temporal.PrecioUni = Convert.ToDecimal(gvlista.CurrentRow.Cells[8].Value);
                    temporal.Importe = Convert.ToDecimal(gvlista.CurrentRow.Cells[9].Value);
                    temporal.Id = Convert.ToInt32(gvlista.CurrentRow.Cells[0].Value);
                    Escorrecto = objtemporal.editarTemporal(temporal);
                    if (Escorrecto) listarDetalle();
                    else men.EditoError();
                }
                catch (Exception ex) { ex.ToString(); }
            }
            return false;
        }
        public void buscarSublinea()
        {
            if(cmdsublinea.SelectedValue==null)
            {
                men.SeleccioneUnDato();
                cmdsublinea.Text = "";
                cmdsublinea.Focus();
            }
            else
            {
                objetopro = obj.buscarSubLinea(cmdsublinea.SelectedValue.ToString());
                gvproducto.DataSource = objetopro;
                ocultarB();
                gvproducto.Visible = true;
                txtcodigo.Text = "";
                txtcodigo.Focus();
            }
        }
        public void buscarProducto()
        {
            objetopro = obj.buscarProductoB(txtcodigo.Text);
            gvproducto.DataSource = objetopro;
            ocultarB();
        }
        public void ocultarB()
        {
            gvproducto.Columns[0].Visible = false;
            gvproducto.Columns[1].Visible = false;
            gvproducto.Columns[2].Visible = false;
            gvproducto.Columns[9].Visible = false;
            gvproducto.Columns[10].Visible = false;
            gvproducto.Columns[11].Visible = false;
            gvproducto.Columns[3].ReadOnly = true;
            gvproducto.Columns[5].ReadOnly = true;
            gvproducto.Columns[6].ReadOnly = true;
            gvproducto.Columns[7].ReadOnly = true;
            gvproducto.Columns[8].ReadOnly = true;
            gvproducto.Columns[3].Width = 440;
            gvproducto.Columns[5].Width =90;
            gvproducto.Columns[5].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvproducto.Columns[7].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvproducto.Columns[8].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
        }
        public void listarDetalle()
        {
            gvlista.ReadOnly = false;
            string xvalue = string.Empty;
            xvalue = xidUsuario.ToString() + "|" + xIGV;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("listaTempoVentaB", "@Data",xvalue);
            if (rpt != "")
            {
                TablaT= Cadena.CrearTabla(rpt);
                vistaT= TablaT.DefaultView;
                bsT= new BindingSource();
                bsT.DataSource = TablaT;
                gvlista.DataSource = bsT;
                ocultarDetalle();
                total();
            }
        }
        public void listarDetalleMesa()
        {
            this.lblidMesa.Text = "";
            string xIdOrden = string.Empty;
            xIdOrden =this.cmdMesas.SelectedValue.ToString();
            this.lblidMesa.Text = xIdOrden;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("usplistaDetalleOrden", "@IdOrden", xIdOrden);
            if (rpt != "")
            {
                string[] LisDetalle= rpt.Split('[');
                TablaT = Cadena.CrearTabla(LisDetalle[0]);
                vistaT = TablaT.DefaultView;
                bsT = new BindingSource();
                bsT.DataSource = TablaT;
                gvlista.DataSource = bsT;
                ocultarDetalle();
                total();
                gvlista.ReadOnly =true;
                txtcodigo.Enabled = false;
                chkbuscar.Enabled = false;
                xPersonal = string.Empty;
                xPersonal = LisDetalle[1].ToString();
                validarFormaPago();
            }
        }
        public void ocultarDetalle()
        {
            gvlista.Columns[0].Visible = false;
            gvlista.Columns[1].Visible = false;
            gvlista.Columns[2].Visible = false;
            gvlista.Columns[3].Visible = false;
            gvlista.Columns[7].Visible = false;
            gvlista.Columns[10].Visible = false;
            gvlista.Columns[11].Visible = false;
            gvlista.Columns[12].Visible = false;
            gvlista.Columns[13].Visible = false;
            gvlista.Columns[14].Visible = false;
            gvlista.Columns[3].ReadOnly=true;
            gvlista.Columns[5].ReadOnly = true;
            gvlista.Columns[6].ReadOnly=true;
            gvlista.Columns[9].ReadOnly = true;
            gvlista.Columns[4].Width =90;
            gvlista.Columns[5].Width =80;
            gvlista.Columns[6].Width =455;
            gvlista.Columns[4].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvlista.Columns[9].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvlista.Columns[8].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
        }
        public void ingresarDetalle()
        {
            if (gvproducto.Rows.Count != 0)
            {
                bool escorecto = false;
                string wid, wUm, xvalorP, xvalorL = string.Empty;
                wid = Convert.ToString(gvproducto.CurrentRow.Cells[0].Value);
                wUm = Convert.ToString(gvproducto.CurrentRow.Cells[6].Value);
                xvalorP = wid + "[" + wUm;
                foreach (DataGridViewRow fila in gvlista.Rows)
                {
                    xvalorL = (Convert.ToString(fila.Cells[2].Value.ToString()) + "[" + Convert.ToString(fila.Cells[5].Value.ToString()));
                    if (xvalorP == xvalorL)
                    {
                        escorecto = true;
                        break;
                    }
                    else
                    {
                        escorecto = false;
                    }
                }
                if (escorecto)
                {
                    men.productoAgregado();
                    gvproducto.CurrentRow.Cells[4].Value = "";
                    gvproducto.Focus();
                }
                else
                {
                    temporal.UsuarioId = xidUsuario.ToString();
                    temporal.IdProducto = Convert.ToInt32(gvproducto.CurrentRow.Cells[0].Value);
                    if (gvproducto.CurrentRow.Cells[4].Value == null || Convert.ToString(gvproducto.CurrentRow.Cells[4].Value) == "")
                        temporal.Cantidad = 1;
                    else
                        temporal.Cantidad = Convert.ToDecimal(gvproducto.CurrentRow.Cells[4].Value);
                    temporal.UM = Convert.ToString(gvproducto.CurrentRow.Cells[6].Value);
                    temporal.PrecioUni = Convert.ToDecimal(gvproducto.CurrentRow.Cells[7].Value);
                    temporal.Importe = (temporal.Cantidad * temporal.PrecioUni);
                    temporal.ValorUm = Convert.ToDecimal(gvproducto.CurrentRow.Cells[10].Value);
                    if (objtemporal.insertarTemporal(temporal)) listarDetalle();
                    else men.ErrorGuardado();
                }
            }
        }
        public void guardar()
        {
            Stopwatch oReloj = new Stopwatch();
            oReloj.Start();
            descuentos();
            string xestado = string.Empty;
            string vdata = string.Empty;
            decimal xmovilidad = 0;
            decimal xdescuento = 0;
            decimal xacuenta = 0;
            int count = gvlista.Rows.Count;
            if (txtmovilidad.Text.Length == 0) xmovilidad = 0;
            else xmovilidad = decimal.Parse(txtmovilidad.Text);
            if (txtdescuento.Text.Length == 0) xdescuento = 0;
            else xdescuento = decimal.Parse(txtdescuento.Text);
            if (txtacuenta.Text.Length == 0) xacuenta = 0;
            else xacuenta = decimal.Parse(txtacuenta.Text);
            if (cmddocumento.Text == "BOLETA") xestado = "EMITIDO";
            else xestado = "PENDIENTE";
            vdata = cmddocumento.Text + "|" + lblidclien.Text + "|" + xPersonal.ToString() + "|" + cmdforma.Text + "|" +
               cmdcondicion.Text + "|" + txtdespacho.Text + "|" + txttelefono.Text + "|" + decimal.Parse(lblsubtotal.Text) + "|" +
               xmovilidad.ToString() + "|" + xdescuento.ToString() + "|" + decimal.Parse(lbltotal.Text) + "|" + xacuenta.ToString() + "|" +
               decimal.Parse(lblsaldo.Text) + "|" + decimal.Parse(lbladicional.Text) + "|" + decimal.Parse(lbltotalTarjeta.Text) + "|" + decimal.Parse(lbltotalpagar.Text) + "|" + xestado + "|" + xIdCompania.ToString() + "|" +
                cmdentrega.Text + "|" + cmdconcepto.Text + "|" + lblserie.Text + "|" + txtnrodoc.Text + "|" + decimal.Parse(lblganancia.Text) + "|" +
                txtletras.Text + "|" + decimal.Parse(lblmtc.Text) + "||" + "PENDIENTE" + "|" + decimal.Parse(lblsubsunat.Text) + "|" +
                decimal.Parse(lbligv.Text) + "|" + xidUsuario +"|"+decimal.Parse(txtefectivo.Text)+"|"+decimal.Parse(lblvuelto.Text)+"|"+lblidMesa.Text+
                "|0|"+double.Parse(xSUB_FIJO.ToString())+"|"+double.Parse(xDES_FIJO.ToString())+"[";
            if (cmdentrega.Text != "POR GUIA SALIDA")
            {
                for (int i = 0; i < count; i++)
                {
                    vdata += Convert.ToString(gvlista.Rows[i].Cells[2].Value);
                    vdata += "|";
                    vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[4].Value);
                    vdata += "|";
                    vdata += Convert.ToString(gvlista.Rows[i].Cells[5].Value);
                    vdata += "|";
                    vdata += Convert.ToString(gvlista.Rows[i].Cells[6].Value);
                    vdata += "|";
                    vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[7].Value);
                    vdata += "|";
                    vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[8].Value);
                    vdata += "|";
                    vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[9].Value);
                    vdata += "|" + xestado + "|";
                    vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[11].Value);
                    if (i == count - 1) break;
                    else vdata += ";";
                }
                vdata += "[";
            }
            else
            {
                //
            }
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("uspinsertarNotaB", "@ListaOrden", vdata);
            if (rpt == "")
            {
                men.ErrorGuardado();
            }
            else
            {
                if (rpt.Equals("false"))
                {
                    MessageBox.Show("No se Aperturo la caja chica...favor de abrir una nueva caja", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    string[] xinfo = rpt.Split('¬');
                    lblidnota.Text = "";
                    txtcodigo.Text = "";
                    txtnrodoc.Text = "";
                    lblidnota.Text = xinfo[0];
                    txtnrodoc.Text = xinfo[1];
                    if (xAvisoPrint == 1) imprimirBoletas();
                    if (xAvisoPrint == 2) imprimir();
                    listar();//enviarB(xinfo[0]);
                    oReloj.Stop();
                    this.Text = ".:.TIEMPO DE RESPUESTA:  " + oReloj.Elapsed.TotalMilliseconds.ToString("N2") + " MS";
                    if (cmdentrega.Text == "POR GUIA SALIDA")
                    {
                        men.GuardoCorrecto();
                        limpiar();
                    }
                    else
                    {
                        xAvisoPrint = 0;
                        gvlista.DataSource = null;
                        btnimprimir.Enabled = false;
                        btnguardar.Enabled = false;
                        btneditar.Enabled = false;
                        btneliminar.Enabled = false;
                        btnactivar.Enabled = true;
                        btncopia.Enabled = true;
                        listarB();
                        desactivarCajas();
                        xCopia = string.Empty;
                        lblvendedor.Text = xPersonal;
                        xPersonal = string.Empty;
                        if (cmddocumento.Text == "FACTURA")abrirFactura();
                    }
                }
            }
        }
        public void abrirFactura()
        {
            xdocu = new FrmDocumento();
            xdocu.xid = lblidnota.Text;
            xdocu.xdocumento = cmddocumento.Text;
            xdocu.xcliente = txtcliente.Text;
            xdocu.xcondicion = "ALCONTADO";
            xdocu.xFormaPago = cmdforma.Text;
            if (txtmovilidad.Text.Length == 0) xdocu.xmovilidad = "0.00";
            else xdocu.xmovilidad = txtmovilidad.Text;
            if (txtdescuento.Text.Length == 0) xdocu.xdescuento = "0.00";
            else xdocu.xdescuento = txtdescuento.Text;
            xdocu.xadicional = lbladicional.Text;
            xdocu.xPersonal = xUsuario;
            xdocu.xEstado = "PENDIENTE";
            xdocu.xCompania = xCompania;
            xdocu.xEfectivo = txtefectivo.Text;
            xdocu.xVuelto = lblvuelto.Text;
            xdocu.xIdUsuario = xidUsuario;
            xdocu.xIMP_BOLSA = xIMP_BOLSA;
            xdocu.xIGV = xIGV;
            xdocu.ShowDialog();
            listar();
        }
        public void listar()
        {
            objeto = objpedido.listar();
            bs = new BindingSource();
            bs.DataSource = objeto;
            gvpanel.DataSource = bs;
            ocultarColumnas();
            totalista();
            cargarMesas();
        }
        public void listarFecha()
        {
            objeto = objpedido.listarFecha(dtimeinicio.Text,dtimefin.Text);
            gvpanel.DataSource = objeto;
            ocultarColumnas();
            this.lblcantidad.Text = gvpanel.Rows.Count.ToString();
            totalista();
        }
        public void ocultarColumnas()
        {                                                                                                                     
            gvpanel.Columns[1].Visible = false;
            //if (xEnvioFactura == "0")
            //gvpanel.Columns[2].Visible = false;
            gvpanel.Columns[2].Visible = true;
            gvpanel.Columns[6].Visible = false;
            gvpanel.Columns[8].Visible = false;
            gvpanel.Columns[9].Visible = false;
            gvpanel.Columns[12].Visible = false;
            gvpanel.Columns[13].Visible = false;
            gvpanel.Columns[25].Visible = false;
            gvpanel.Columns[26].Visible = false;
            gvpanel.Columns[27].Visible = false;
            gvpanel.Columns[28].Visible = false;
            gvpanel.Columns[30].Visible = false;
            gvpanel.Columns[33].Visible = false;
            gvpanel.Columns[34].Visible = false;
            gvpanel.Columns[35].Visible = false;
            gvpanel.Columns[36].Visible = false;
            gvpanel.Columns[3].Width = 80;
            gvpanel.Columns[4].Width = 110;
            gvpanel.Columns[5].Width = 140;
            gvpanel.Columns[7].Width = 348;
            gvpanel.Columns[9].Width = 80;
            gvpanel.Columns[14].Width = 110;
            gvpanel.Columns[15].Width = 110;
            gvpanel.Columns[16].Width = 110;
            gvpanel.Columns[17].Width = 110;
            gvpanel.Columns[18].Width = 110;
            gvpanel.Columns[19].Width = 110;
            gvpanel.Columns[20].Width = 110;
            gvpanel.Columns[21].Width = 110;
            gvpanel.Columns[22].Width = 110;
            gvpanel.Columns[23].Width = 150;
            gvpanel.Columns[24].Width = 150;
            gvpanel.Columns[29].Width = 110;
            gvpanel.Columns[31].Width = 140;
            gvpanel.Columns[32].Width = 120;
            gvpanel.Columns[14].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[15].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[16].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[17].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[18].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[19].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[20].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[21].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[22].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvpanel.Columns[7].Frozen = true;
        }
       #endregion
        #region Busqueda
        public bool buscarCNumero(ElistaNota xnota)
        {
            return (xnota.Numero.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarNumero()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCNumero);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCForma(ElistaNota xnota)
        {
            return (xnota.FormaPago.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarForma()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCForma);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCCliente(ElistaNota xnota)
        {
            return (xnota.Cliente.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarCliente()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCCliente);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCDocumento(ElistaNota xnota)
        {
            return (xnota.Documento.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarDocumento()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCDocumento);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCUsuario(ElistaNota xnota)
        {
            return (xnota.Atendido_Por.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarUsuario()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCUsuario);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCEstado(ElistaNota xnota)
        {
            return (xnota.Estado.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarEstado()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCEstado);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCCondicion(ElistaNota xnota)
        {
            return (xnota.Condicion.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarCondicion()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCCondicion);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCRUC(ElistaNota xnota)
        {
            return (xnota.RUC.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarRUC()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCRUC);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCDNI(ElistaNota xnota)
        {
            return (xnota.DNI.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarDNI()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCDNI);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        public bool buscarCEntrega(ElistaNota xnota)
        {
            return (xnota.Entrega.ToUpper().Contains(txtbuscar.Text.ToUpper()));
        }
        public void buscarEntrega()
        {
            Predicate<ElistaNota> pre = new Predicate<ElistaNota>(buscarCEntrega);
            gvpanel.DataSource = objeto.FindAll(pre);
            totalista();
        }
        #endregion
        #region filtrar
        public void filtrar()
        {
            if (cmdfiltrar.Text == "NUMERO") lblbuscar.Text = "Numero:";
            else if (cmdfiltrar.Text == "DOCUMENTO") lblbuscar.Text = "Documento:";
            else if (cmdfiltrar.Text == "FORMAPAGO") lblbuscar.Text = "Forma Pago:";
            else if (cmdfiltrar.Text == "VENDEDOR") lblbuscar.Text = "Vendedor:";
            else if (cmdfiltrar.Text == "ESTADO") lblbuscar.Text = "Estado:";
            else if (cmdfiltrar.Text == "CONDICION") lblbuscar.Text = "Condicion:";
            else if (cmdfiltrar.Text == "RUC") lblbuscar.Text = "RUC:";
            else if (cmdfiltrar.Text == "DNI") lblbuscar.Text = "DNI:";
            else if (cmdfiltrar.Text == "ENTREGA") lblbuscar.Text = "Entrega:";
            else lblbuscar.Text = "Cliente:";
            txtbuscar.Text = "";
        }
        #endregion
        #region MetodosEditar
        public bool insertadetalleB()
        {
            bool escorecto = false;
            string wid, wUm, xvalorP, xvalorL = string.Empty;
            wid = Convert.ToString(gvproducto.CurrentRow.Cells[0].Value);
            wUm = Convert.ToString(gvproducto.CurrentRow.Cells[6].Value);
            xvalorP = wid + "[" + wUm;
            foreach (DataGridViewRow fila in gvlista.Rows)
            {
                xvalorL = (Convert.ToString(fila.Cells[2].Value.ToString()) + "[" + Convert.ToString(fila.Cells[5].Value.ToString()));
                if (xvalorP == xvalorL)
                {
                    escorecto = true;
                    break;
                }
                else
                {
                    escorecto = false;
                }
            }
            if (escorecto)
            {
                men.productoAgregado();
                gvproducto.CurrentRow.Cells[4].Value = "";
                gvproducto.Focus();
            }
            else
            {
                bool Escorrecto = false;
                detalle.NotaId = int.Parse(lblidnota.Text);
                detalle.IdProducto = Convert.ToInt32(gvproducto.CurrentRow.Cells[0].Value);
                detalle.Descripcion = Convert.ToString(gvproducto.CurrentRow.Cells[3].Value);
                if (gvproducto.CurrentRow.Cells[4].Value == null)
                    detalle.Cantidad = 1;
                else
                    detalle.Cantidad = Convert.ToDecimal(gvproducto.CurrentRow.Cells[4].Value);
                detalle.UMedida = Convert.ToString(gvproducto.CurrentRow.Cells[6].Value);
                detalle.Precio_Uni = Convert.ToDecimal(gvproducto.CurrentRow.Cells[7].Value);
                detalle.Pre_Costo = Convert.ToDecimal(gvproducto.CurrentRow.Cells[9].Value);
                detalle.Importe = (detalle.Cantidad * detalle.Precio_Uni);
                detalle.Estado = "PENDIENTE";
                detalle.valorUM = Convert.ToDecimal(gvproducto.CurrentRow.Cells[10].Value);
                Escorrecto = objpedido.insertaDetaB(detalle, "0");
                if (Escorrecto)
                {
                    listarB();
                    total();
                }
                else
                {
                    men.ErrorGuardado();
                }
            }
            return false;
        }
        public void editaItemsB()
        {
            string xdata, xid= string.Empty;
            double xcantidad, xcosto, xprecio, ximporte;
            xid = Convert.ToString(gvlista.CurrentRow.Cells[0].Value);
            xcantidad = Convert.ToDouble(gvlista.CurrentRow.Cells[4].Value);
            xcosto = Convert.ToDouble(gvlista.CurrentRow.Cells[7].Value);
            xprecio = Convert.ToDouble(gvlista.CurrentRow.Cells[8].Value);
            ximporte = Convert.ToDouble(gvlista.CurrentRow.Cells[9].Value);
            xdata = xid + "|" + xcantidad + "|" + xcosto + "|" + xprecio + "|" + ximporte + "|" + double.Parse(lblganancia.Text);
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("editaNotaLD", "@Data", xdata);
            if (rpt != "true")men.ErrorGuardado();
        }
        public void editadetalle()
        {
            Stopwatch oReloj = new Stopwatch();
            oReloj.Start();
            descuentos();
            string xestado = string.Empty;
            string vdata = string.Empty;
            decimal xacuenta = 0;
            int count = gvlista.Rows.Count;
            if (txtacuenta.Text.Length == 0) xacuenta = 0;
            else xacuenta = decimal.Parse(txtacuenta.Text);
            if (cmddocumento.Text == "BOLETA") xestado = "EMITIDO";
            else xestado = "PENDIENTE";
            vdata = cmddocumento.Text + "|" + lblidclien.Text + "|" + xPersonal + "|" + cmdforma.Text + "|" +
               "ALCONTADO|" + txtfiscal.Text + "||" + decimal.Parse(lblsubtotal.Text) + "|" +
               "0|0|" + decimal.Parse(lblsubtotal.Text) + "|" + xacuenta.ToString() + "|" +
               decimal.Parse(lblsaldo.Text) + "|" + decimal.Parse(lbladicional.Text) + "|" + decimal.Parse(lbltotalTarjeta.Text) + "|" + decimal.Parse(lbltotalpagar.Text) + "|" + xestado + "|" + xIdCompania.ToString() + "|" +
                cmdentrega.Text + "|" + cmdconcepto.Text + "|" + lblserie.Text + "|" + txtnrodoc.Text + "|" + decimal.Parse(lblganancia.Text) + "|" +
                txtletras.Text + "|" + decimal.Parse(lblmtc.Text) + "||" + "PENDIENTE" + "|" + decimal.Parse(lblsubsunat.Text) + "|" +
                decimal.Parse(lbligv.Text) + "|" + xidUsuario + "|" + lblidnota.Text +"|"+decimal.Parse(txtefectivo.Text)+"|"+decimal.Parse(lblvuelto.Text) +
                "|0|" + double.Parse(xSUB_FIJO.ToString()) + "|" + double.Parse(xDES_FIJO.ToString()) + "[";
            for (int i = 0; i < count; i++)
            {
                vdata += Convert.ToString(gvlista.Rows[i].Cells[0].Value);
                vdata += "|";
                vdata += Convert.ToString(gvlista.Rows[i].Cells[2].Value);
                vdata += "|";
                vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[4].Value);
                vdata += "|";
                vdata += Convert.ToString(gvlista.Rows[i].Cells[5].Value);
                vdata += "|";
                vdata += Convert.ToString(gvlista.Rows[i].Cells[6].Value);
                vdata += "|";
                vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[7].Value);
                vdata += "|";
                vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[8].Value);
                vdata += "|";
                vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[9].Value);
                vdata += "|" + xestado + "|";
                vdata += Convert.ToDecimal(gvlista.Rows[i].Cells[13].Value);
                if (i == count - 1) break;
                else vdata += ";";
            }
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("uspEditarNotaB", "@ListaOrden", vdata);
            if (rpt == "")
            {
                men.ErrorGuardado();
            }
            else if (rpt.Equals("false"))
            {
                MessageBox.Show("No se Aperturo la caja chica...favor de abrir una nueva caja", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                txtcodigo.Text = "";
                txtnrodoc.Text = "";
                txtnrodoc.Text = rpt;
                if (xAvisoPrint == 1) imprimirBoletas();
                if (xAvisoPrint == 2) imprimir();
                listar();//enviarC();
                oReloj.Stop();
                this.Text = ".:.TIEMPO DE RESPUESTA:  " + oReloj.Elapsed.TotalMilliseconds.ToString("N2") + " MS";
                if (!cmddocumento.Text.Contains("BOLETA")) men.GuardoCorrecto();
                xAvisoPrint = 0;
                traerDatos();
                listarB();
                buscarTexto();
                btnimprimir.Enabled = false;
                btnguardar.Enabled = false;
                btneditar.Enabled = false;
                btneliminar.Enabled = false;
                btnactivar.Enabled = true;
                btncopia.Enabled = true;
                desactivarCajas();
                if (cmddocumento.Text == "FACTURA") abrirFactura();
            }
        }
        public void desactivarCajas()
        {
            chkLlevar.Enabled = false;
            chkbuscar.Enabled = false;
            chkbuscar.Checked = false;
            chkLlevar.Checked = false;
            cmdMesas.Enabled = false;
            cmdentrega.Enabled = false;
            cmdconcepto.Enabled = false;
            cmddocumento.Enabled = false;
            cmdcompania.Enabled = false;
            cmdcondicion.Enabled = false;
            cmdsublinea.Enabled =false;
            cmdforma.Enabled = false;
            //txtnrodoc.Enabled = false;
            detimepago.Enabled = false;
            txtcliente.Enabled=false;
            txtruc.Enabled=false;
            txtdni.Enabled=false;
            btncliente.Enabled = false;
            txtcodigo.ReadOnly = true;
            txtdespacho.ReadOnly = true;
            txttelefono.ReadOnly =true;
            txtmovilidad.Enabled=false;
            txtdescuento.Enabled=false;
            txtacuenta.ReadOnly = true;
            txtefectivo.Enabled=false;
            gvlista.ReadOnly = true;
        }
        public void activarCajas()
        {
            chkLlevar.Enabled = true;
            chkbuscar.Enabled = true;
            cmdMesas.Enabled = true;
            cmdconcepto.Enabled = true;
            cmdentrega.Enabled = true;
            cmdcondicion.Enabled = true;
            cmddocumento.Enabled = true;
            cmdsublinea.Enabled = true;
            cmdforma.Enabled = true;
            txtcliente.Enabled = true;
            txtruc.Enabled = true;
            txtdni.Enabled = true;
            btncliente.Enabled = true;
            txtcodigo.ReadOnly = false;
            txtdespacho.ReadOnly = false;
            txttelefono.ReadOnly = false;
            txtmovilidad.Enabled =true;
            txtdescuento.Enabled=true;
            chkbuscar.Enabled = true;
            txtefectivo.Enabled=true;
            gvlista.ReadOnly = false;
        }
        public bool eliminarPedido()
        {
            bool Escorrecto = false;
            if (lblidnota.Text.Length == 0 || gvlista.Rows.Count <= 0)
            {
                men.SeleccioneUnDato();
            }
            else
            {
                SqlTransaction tr = null;
                SqlConnection cn = new SqlConnection(MetodosGlobales.GetConexion(Constantes.APP_KEY_DATABASE));
                cn.Open();
                tr = cn.BeginTransaction(System.Data.IsolationLevel.ReadCommitted);
                DaoNotaPedido dao = new DaoNotaPedido(cn, tr);
                string xidguia, xidnota = string.Empty;
                xidnota = lblidnota.Text;
                if (cmdentrega.Text == "POR GUIA SALIDA")
                {
                    foreach (DataGridViewRow row in listaReB.Rows)
                    {
                        xidguia = Convert.ToString(row.Cells[0].Value);
                        Escorrecto = dao.eliminarGuia(xidguia, xidnota);
                        if (!Escorrecto) break;
                    }
                    if (Escorrecto) Escorrecto = dao.eliminarPedido(xidnota);
                    else Escorrecto = false;
                }
                else
                {
                    Escorrecto = dao.eliminarPedido(xidnota);
                }
                if (Escorrecto)
                {
                    tr.Commit();
                    listar();//enviar();
                    men.EliminoCorrecto();
                    limpiar();
                    listarDetalle();
                }
                else
                {
                    tr.Rollback();
                    men.EliminoError();
                }
                cn.Close();
                tr.Dispose();
                cn.Dispose();
            }
            return false;
        }
        public void listarB()
        {
            string xvalue = string.Empty;
            xvalue = this.lblidnota.Text + "|" + xIGV;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarComando("listaDetalleNotaB", "@Data",xvalue);
            if (rpt != "")
            {
                listas = rpt.Split('[');
                Tabla= Cadena.CrearTabla(listas[0]);
                vista = Tabla.DefaultView;
                bs = new BindingSource();
                bs.DataSource = Tabla;
                gvlista.DataSource = bs;
                Cadena.ConfigurarGrilla(gvlista,Tabla);
                ocultarColumnaB();
                if (lblestado.Text != "CANCELADO")total();
                else calcularB();
                if (cmdentrega.Text == "POR GUIA SALIDA")
                {
                    listaGuias = Cadena.AlistaCampos(listas[1]);
                    listaReB.DataSource = listaGuias;
                }
            }
        }
        public void ocultarColumnaB()
        {
            gvlista.Columns[0].Visible = false;
            gvlista.Columns[1].Visible = false;
            gvlista.Columns[2].Visible = false;
            gvlista.Columns[3].Visible = false;
            gvlista.Columns[7].Visible = false;
            gvlista.Columns[10].Visible = false;
            gvlista.Columns[11].Visible = false;
            gvlista.Columns[12].Visible = false;
            gvlista.Columns[13].Visible = false;
            gvlista.Columns[14].Visible = false;
            gvlista.Columns[15].Visible = false;
            gvlista.Columns[16].Visible = false;
            gvlista.Columns[5].ReadOnly = true;
            gvlista.Columns[6].ReadOnly = true;
            gvlista.Columns[9].ReadOnly = true;
            gvlista.Columns[4].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvlista.Columns[9].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            gvlista.Columns[8].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
        }
        #endregion
        #region traerInforme
        public void traerDNI()
        {
            if (txtdni.Text.Length == 0)
            {
                men.datosVacios();
                txtdni.Focus();
            }
            else
            {
                DataTable datos = objcliente.traerDNI(this.txtdni.Text);
                if (datos.Rows.Count == 0)
                {
                    MessageBox.Show("El DNI que escribio no existe...favor de crearlo", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtcliente.Text = "";
                    txtruc.Text = "";
                    txtdni.Text = "";
                    lblidclien.Text = "";
                    txtfiscal.Text = "";
                    txtdespacho.Text = "";
                    txttelefono.Text = "";
                    txtdni.Focus();
                }
                else
                {
                    lblidclien.Text = datos.Rows[0][0].ToString();
                    txtcliente.Text = datos.Rows[0][1].ToString();
                    txtruc.Text = datos.Rows[0][2].ToString();
                    txtfiscal.Text = datos.Rows[0][4].ToString();
                    txttelefono.Text = "";
                    txttelefono.Text = datos.Rows[0][6].ToString();
                    txtdespacho.Text = datos.Rows[0][9].ToString();
                    txtfiscal.Focus();
                }
            }
        }
        public void traerRUC()
        {
            if (txtruc.Text.Length == 0)
            {
                men.datosVacios();
                txtruc.Focus();
            }
            else
            {
                DataTable datos = objcliente.traerRUC(this.txtruc.Text);
                if (datos.Rows.Count == 0)
                {
                    MessageBox.Show("El RUC que escribio no existe...favor de crearlo", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtcliente.Text = "";
                    txtruc.Text = "";
                    txtdni.Text = "";
                    lblidclien.Text = "";
                    txtfiscal.Text = "";
                    txtdespacho.Text = "";
                    txttelefono.Text = "";
                    txtruc.Focus();
                }
                else
                {
                    lblidclien.Text = datos.Rows[0][0].ToString();
                    txtcliente.Text = datos.Rows[0][1].ToString();
                    txtdni.Text = datos.Rows[0][3].ToString();
                    txtfiscal.Text = datos.Rows[0][4].ToString();
                    txttelefono.Text = "";
                    txttelefono.Text = datos.Rows[0][6].ToString();
                    txtdespacho.Text = datos.Rows[0][9].ToString();
                    txtfiscal.Focus();
                }
            }
        }
        public void traerDatos()
        {
            if (txtcliente.Text.Length == 0)
            {
                men.datosVacios();
                txtcliente.Focus();
            }
            else
            {
                DataTable datos = objcliente.traerCliente(this.txtcliente.Text.Trim());
                if (datos.Rows.Count == 0)
                {
                    MessageBox.Show("El Cliente que escribio no existe...favor de crearlo", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtcliente.Text = "";
                    txtruc.Text = "";
                    txtdni.Text = "";
                    lblidclien.Text = "";
                    txtfiscal.Text = "";
                    txtdespacho.Text = "";
                    txttelefono.Text = "";
                    txtcliente.Focus();
                }
                else
                {
                    lblidclien.Text = datos.Rows[0][0].ToString();
                    txtruc.Text = datos.Rows[0][2].ToString();
                    txtdni.Text = datos.Rows[0][3].ToString();
                    txtfiscal.Text = datos.Rows[0][4].ToString();
                    txttelefono.Text = "";
                    txttelefono.Text = datos.Rows[0][6].ToString();
                    txtdespacho.Text = datos.Rows[0][9].ToString();
                    txtfiscal.Focus();
                }
            }
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
                    DataGridViewRow row = gvlista.Rows.Cast<DataGridViewRow>().FirstOrDefault(x => Convert.ToString(x.Cells[2].Value) == xid);
                    if (row != null)
                    {
                        temporal.IdProducto = int.Parse(xid.ToString());
                        temporal.UsuarioId = xidUsuario.ToString();
                        if (objtemporal.editarTemporalB(temporal))
                        {
                            listarDetalle();
                            validarFormaPago();
                            txtcodigo.Text = "";
                            txtcodigo.Focus();
                        }
                        else
                            men.EditoError();
                    }
                    else
                    {
                        temporal.UsuarioId = xidUsuario.ToString();
                        temporal.IdProducto = int.Parse(xid);
                        temporal.Cantidad = 1;
                        temporal.UM = datos.Rows[0][5].ToString();
                        temporal.PrecioUni = decimal.Parse(datos.Rows[0][6].ToString());
                        temporal.Importe = temporal.PrecioUni;
                        temporal.ValorUm = 1;
                        if (objtemporal.insertarTemporal(temporal))
                        {
                            listarDetalle();
                            validarFormaPago();
                            txtcodigo.Text = "";
                            txtcodigo.Focus();
                        }
                        else
                            men.ErrorGuardado();
                    }
                }
            }
        }
        public void traerB()
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
                    string xdata = string.Empty;
                    string xid = datos.Rows[0][0].ToString();
                    DataGridViewRow row = gvlista.Rows.Cast<DataGridViewRow>().FirstOrDefault(x => Convert.ToString(x.Cells[2].Value) == xid);
                    if (row != null)
                    {
                        xdata = xid + "|" + lblidnota.Text;
                        AccesoDatos daSQL = new AccesoDatos("con");
                        string rpt = daSQL.ejecutarComando("ldTraerDetalle", "@Data", xdata);
                        if (rpt == "true")
                        {
                            listarB();
                            txtcodigo.Text = "";
                            txtcodigo.Focus();
                        }
                        else
                            men.EditoError();
                    }
                    else
                    {
                        detalle.NotaId = int.Parse(lblidnota.Text);
                        detalle.IdProducto = int.Parse(xid);
                        detalle.Cantidad = 1;
                        detalle.Descripcion = datos.Rows[0][3].ToString();
                        detalle.UMedida = datos.Rows[0][5].ToString();
                        detalle.Precio_Uni = decimal.Parse(datos.Rows[0][6].ToString());
                        detalle.Pre_Costo = Convert.ToDecimal(datos.Rows[0][8].ToString());
                        detalle.Importe = detalle.Precio_Uni;
                        detalle.Estado = "PENDIENTE";
                        detalle.CantidadSaldo = 0;
                        detalle.valorUM = 1;
                        if (objpedido.insertaDetaB(detalle,"0"))
                        {
                            listarB();
                            txtcodigo.Text = "";
                            txtcodigo.Focus();
                        }
                        else
                        {
                            men.ErrorGuardado();
                        }
                    }
                }
            }
        }
        #endregion
        private void calcularB()
        {
            decimal xgana = 0;
            if (gvlista.Rows.Count > 0)
            {
                foreach (DataGridViewRow row in gvlista.Rows)
                {
                    xgana += (Convert.ToDecimal(row.Cells[8].Value) - Convert.ToDecimal(row.Cells[7].Value)) * Convert.ToDecimal(row.Cells[4].Value);
                }
            }
            if (xgana <= 0) lblganancia.ForeColor = Color.Red;
            else lblganancia.ForeColor = Color.Black;
            lblganancia.Text = (xgana).ToString("N2");
            this.lblitems.Text = gvlista.Rows.Count.ToString();
        }
        private void total()
        {
            double xtotal = 0;
            double xgana = 0;
            double vsub_fijo = 0;
            if (gvlista.Rows.Count > 0)
            {
                foreach (DataGridViewRow row in gvlista.Rows)
                {
                    xgana += (Convert.ToDouble(row.Cells[8].Value) - Convert.ToDouble(row.Cells[7].Value)) * Convert.ToDouble(row.Cells[4].Value);
                    xtotal += Convert.ToDouble(row.Cells[9].Value);
                }
            }
            if (xgana <= 0) lblganancia.ForeColor = Color.Red;
            else lblganancia.ForeColor = Color.Black;
            //vsub_fijo = ((xtotal) / 1.18);
            vsub_fijo = ((xtotal) / xIGVD);
            xSUB_FIJO = vsub_fijo.ToString("N2");
            lblganancia.Text = (xgana).ToString("N2");
            lblsubtotal.Text = (xtotal).ToString("N2");
            this.lblitems.Text = gvlista.Rows.Count.ToString();
            descuentos();
        }
        public void totalista()
        {
            if (xArea == "GERENCIA Y ADMINISTRACION")
            {
                decimal tarjeta = 0;
                decimal total = 0;
                decimal efectivo = 0;
                if (gvpanel.Rows.Count > 0)
                {
                    foreach (DataGridViewRow row in gvpanel.Rows)
                    {
                        if (Convert.ToString(row.Cells[24].Value) == "CANCELADO")
                        {
                            if (Convert.ToString(row.Cells[11].Value) == "EFECTIVO")
                                efectivo += Convert.ToDecimal(row.Cells[14].Value);
                            else
                                tarjeta += Convert.ToDecimal(row.Cells[14].Value);
                        }
                    }
                    total = efectivo + tarjeta;
                    lbltarjeta.Text = (tarjeta).ToString("N2");
                    lblefectivo.Text = (efectivo).ToString("N2");
                    lbltotalB.Text = (total).ToString("N2");
                }
                else
                {
                    lblefectivo.Text = "0.00";
                    lbltarjeta.Text = "0.00";
                    lbltotalB.Text = "0.00";
                }
            }
            this.lblcantidad.Text = gvpanel.Rows.Count.ToString();
        }
        //private async Task recibirMensaje()
        //{
        //    while (true)
        //    {
        //        byte[] buffer = new byte[1024];
        //        ArraySegment<byte> data = new ArraySegment<byte>(buffer);
        //        WebSocketReceiveResult rpta = await cliente.ReceiveAsync(data, CancellationToken.None);
        //        if (rpta.Count > 0)
        //        {
        //            string msg = "";
        //            for (int i = 0; i < buffer.Length; i++)
        //            {
        //                if (buffer[i] != 0) msg += (char)buffer[i];
        //                else break;
        //            }
        //            listar();
        //        }
        //    } 
        //}
        Conexion conexion = new Conexion();
        private void FrmNotaPedido_Load(object sender, EventArgs e)
        {
            cargarload();
            //try
            //{
            //    cliente = new ClientWebSocket();
            //    Uri ipservidor = new Uri(conexion.Cadena);
            //    await cliente.ConnectAsync(ipservidor, CancellationToken.None);
            //    await recibirMensaje();
            //}
            //catch (Exception ex)
            //{
            //    ex.ToString();
            //    MessageBox.Show("Se desconecto del Servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            //    this.Close();
            //}
        }
        FrmHistoria xHistoria;
        private void gvlista_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                if (btnguardar.Enabled == true)
                {
                    eliminar();
                    validarFormaPago();
                }
                else
                {
                    string xestado, xnroguias;
                    DataTable datos = objpedido.traerGuia(lblidnota.Text);
                    if (datos.Rows.Count == 0)
                    {
                        xestado = "PENDIENTE";
                        xnroguias = "0";
                    }
                    else
                    {
                        xestado = datos.Rows[0][1].ToString();
                        xnroguias = datos.Rows[0][2].ToString();
                    }
                    if (btneditar.Enabled == true)
                    {
                        if (int.Parse(xnroguias) == 0)
                        {
                            if (cmdentrega.Text == "POR GUIA SALIDA")
                            {
                                MessageBox.Show("No puedes eliminar el item seleccionado porque su entrega fue por guia de salida", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            }
                            else
                            {
                                if (xestado.Contains("PENDIENTE") || xestado.Contains("ANULADO"))
                                {
                                    eliminardetalle();
                                    validarFormaPago();
                                }
                                else
                                    MessageBox.Show("No puedes eliminar el item seleccionado porque el documento ya esta (cancelado o emitido)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            }
                        }
                        else
                        {
                            MessageBox.Show("No puedes eliminar el item seleccionado porque este documento ya tiene guias de salidas registradas", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                    }
                }
            }
            else if (e.KeyCode == Keys.ShiftKey)
            {
                txtcodigo.Focus();
            }
            else if (e.KeyCode == Keys.F1)
            {
                if (gvlista.Rows.Count >= 1)
                {
                    e.SuppressKeyPress = true;
                    xHistoria = new FrmHistoria();
                    xHistoria.xidclien = lblidclien.Text;
                    xHistoria.xCliente = "Cliente: " + txtcliente.Text;
                    xHistoria.xidpro = Convert.ToString(gvlista.CurrentRow.Cells[2].Value);
                    xHistoria.xProducto = Convert.ToString(gvlista.CurrentRow.Cells[6].Value);
                    xHistoria.ShowDialog();
                }
            }
            else if (e.KeyCode == Keys.F9)
            {
                string xestado, xnroguias;
                DataTable datos = objpedido.traerGuia(lblidnota.Text);
                if (datos.Rows.Count == 0)
                {
                    xestado = "PENDIENTE";
                    xnroguias = "0";
                }
                else
                {
                    xestado = datos.Rows[0][1].ToString();
                    xnroguias = datos.Rows[0][2].ToString();
                }
                if (int.Parse(xnroguias) == 0)
                {
                    if (xestado == "PENDIENTE")
                        editarPrecioA();
                    else
                        MessageBox.Show("No puedes editar el item seleccionado porque el documento ya esta (cancelado o emitido)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    MessageBox.Show("No puedes editar el item seleccionado porque este documento ya tiene guias de salidas registradas", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            else if (e.KeyCode == Keys.F2)
            {
                if (gvlista.Rows.Count > 0)
                {
                    FrmImagen frm = new FrmImagen();
                    string xruta, xnombre = string.Empty;
                    xnombre = (Convert.ToString(gvlista.CurrentRow.Cells[6].Value));
                    if (btnguardar.Enabled == true)
                        xruta = (Convert.ToString(gvlista.CurrentRow.Cells[10].Value));
                    else
                        xruta = (Convert.ToString(gvlista.CurrentRow.Cells[12].Value));
                    frm.xNombre = xnombre;
                    frm.xRuta = xruta;
                    frm.Show();
                }
            }
        }
        private void gvlista_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            if (gvlista.CurrentCell.ColumnIndex == 4 || gvlista.CurrentCell.ColumnIndex == 7)
            {
                TextBox texto = e.Control as TextBox;
                if (texto != null)
                {
                    texto.KeyPress -= new KeyPressEventHandler(dgv);
                    texto.KeyPress += new KeyPressEventHandler(dgv);
                }
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
        private void gvlista_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                decimal xcantidad = 0;
                decimal col_precio_unitario = 0;
                decimal ximporte = 0;
                if (gvlista.Columns[e.ColumnIndex].Name.Equals("Cantidad"))
                {
                    if (Convert.ToDecimal(gvlista.CurrentRow.Cells[4].Value) == 0)
                    {
                        MessageBox.Show("La cantidad no puede ser cero", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                        if (btnguardar.Enabled == true) listarDetalle();
                        else listarB();
                        gvlista.Focus();
                    }
                    else
                    {
                        if (gvlista.Rows[e.RowIndex].Cells[4].Value != null)
                            if (!decimal.TryParse(gvlista.Rows[e.RowIndex].Cells[4].Value.ToString(), out xcantidad))
                                return;
                        if (gvlista.Rows[e.RowIndex].Cells[8].Value != null)
                            if (!decimal.TryParse(gvlista.Rows[e.RowIndex].Cells[8].Value.ToString(), out col_precio_unitario))
                                return;
                        ximporte = xcantidad * col_precio_unitario;
                        gvlista.Rows[e.RowIndex].Cells[9].Value = Math.Round(ximporte, 2);
                        total();
                        if (btnguardar.Enabled == true) editarItems();
                        else editaItemsB();
                        validarFormaPago();
                    }
                    gvlista.CurrentCell = gvlista.CurrentRow.Cells[4];
                }
                else if (gvlista.Columns[e.ColumnIndex].Name.Equals("PrecioUni") || gvlista.Columns[e.ColumnIndex].Name.Equals("Precio_Uni"))
                {
                    if (Convert.ToDecimal(gvlista.CurrentRow.Cells[8].Value) < Convert.ToDecimal(gvlista.CurrentRow.Cells[7].Value))
                    {
                        MessageBox.Show("El precio unitario esta por muy debajo del precio venta B(Verificar...)", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                        if (btnguardar.Enabled == true) listarDetalle();
                        else listarB();
                        gvlista.Focus();
                    }
                    else
                    {
                        if (gvlista.Rows[e.RowIndex].Cells[4].Value != null)
                            if (!decimal.TryParse(gvlista.Rows[e.RowIndex].Cells[4].Value.ToString(), out xcantidad))
                                return;
                        if (gvlista.Rows[e.RowIndex].Cells[8].Value != null)
                            if (!decimal.TryParse(gvlista.Rows[e.RowIndex].Cells[8].Value.ToString(), out col_precio_unitario))
                                return;
                        ximporte = xcantidad * col_precio_unitario;
                        gvlista.Rows[e.RowIndex].Cells[9].Value = Math.Round(ximporte, 2);
                        total();
                        if (btnguardar.Enabled == true) editarItems();
                        else editaItemsB();
                        validarFormaPago();
                    }
                    gvlista.CurrentCell = gvlista.CurrentRow.Cells[8];
                }
            }
            catch (Exception ex) { ex.ToString(); } 
        }
        public void descuentos()
        {
            double xdescuento, xsubtotal, xpagar, 
            xmovilidad, xacuenta, xtarjeta, xadicional, xtotal;
            double xsaldo = 0;
            double xsmtc = 0;
            double xSubSunat = 0;
            double xigv = 0;
            double xefectivo = 0;
            double xvuelto = 0;
            xsubtotal = double.Parse(lblsubtotal.Text);
            if (txtmovilidad.Text.Length == 0)
                xmovilidad = 0;
            else
                xmovilidad = double.Parse(txtmovilidad.Text);
            if (txtdescuento.Text.Length == 0)
            {
                xdescuento = 0;
                xDES_FIJO = "0.00";
            }
            else
            {
                xdescuento = double.Parse(txtdescuento.Text);
                //xDES_FIJO = (xdescuento / 1.18).ToString("N2");
                xDES_FIJO = (xdescuento / xIGVD).ToString("N2");
            }
            if (txtacuenta.Text.Length == 0)
                xacuenta = 0;
            else
                xacuenta = double.Parse(txtacuenta.Text);
            if (txtefectivo.Text.Length == 0)
                xefectivo = 0;
            else
                xefectivo = double.Parse(txtefectivo.Text);
            xpagar = (xsubtotal + xmovilidad) - xdescuento;
            if (cmdforma.Text == "TARJETA")
            {
                xtarjeta = Math.Round(((xpagar * 104.5) / 100), 3);
                xadicional = Math.Round((xtarjeta - xpagar), 3);
            }
            else
            {
                xtarjeta = 0;
                xadicional = 0;
            }
            xsmtc = (xmovilidad + xadicional);
            lbltotal.Text = (xpagar).ToString("N2");
            xsaldo = (xpagar + xadicional) - xacuenta;
            xtotal = xpagar + xadicional;
            lblsaldo.Text = (xsaldo).ToString("N2");
            lbladicional.Text = (xadicional).ToString("N2");
            lbltotalTarjeta.Text = (xtarjeta).ToString("N2");
            lbltotalpagar.Text = (xtotal).ToString("N2");
            lblmtc.Text = (xsmtc).ToString("N2");
            //xSubSunat = (double.Parse(lbltotalpagar.Text) / 1.18);
            xSubSunat = (double.Parse(lbltotalpagar.Text) / xIGVD);
            lblsubsunat.Text = xSubSunat.ToString("N2");
            xigv = (double.Parse(lbltotalpagar.Text) - double.Parse(lblsubsunat.Text));
            lbligv.Text = xigv.ToString("N2");
            xvuelto = xefectivo - double.Parse(lbltotalpagar.Text);
            lblvuelto.Text = xvuelto.ToString("N2");
            txtletras.Text = Letras.enletras(lbltotalpagar.Text) + "  SOLES";
        }
         private void txtcodigo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (gvproducto.Visible == true)
            {
                if (e.KeyChar == (char)13)
                {
                    e.Handled = true;
                    gvproducto.Focus();
                }
                else
                {
                    e.Handled = false;
                }
            }
            else
            {
                if (e.KeyChar == (char)13)
                {
                    e.Handled = true;
                    if (btnguardar.Enabled == true)
                    {
                        if (chkbuscar.Checked ==false)
                        {
                            if (txtcodigo.Text.Length == 0) gvlista.Focus();
                            else traer();
                        }
                        else
                        {
                            gvlista.Focus();
                        }
                    }
                    else
                    {
                        if (chkbuscar.Checked ==false)
                        {
                            if (txtcodigo.Text.Length == 0) gvlista.Focus();
                            else traerB();
                        }
                        else
                        {
                            gvlista.Focus();
                        }
                    }
                }
                else
                {
                    e.Handled = false;
                }
            }
        }
        private void txtruc_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)32) e.Handled = true;
            Validar.SoloNumeros(e);
        }
        private void txtdni_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)32)
            {
                e.Handled = true;
            }
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txtcodigo.Focus();
            }
            Validar.SoloNumeros(e);
        }
        FrmClientes xcliente;
        public void abrirCliente()
        {
            xcliente = new FrmClientes();
            txtcliente.Text = "";
            txtdni.Text = "";
            txtruc.Text = "";
            lblidclien.Text = "";
            txtfiscal.Text = "";
            xcliente.xUsuario = xUsuario;
            xcliente.xArea = xArea;
            xcliente.MinimizeBox = false;
            xcliente.MaximizeBox = false;
            xcliente.xAviso = 1;
            xcliente.ShowDialog();
            xcliente.xAviso = 0;
            txtcliente.AutoCompleteCustomSource = AutoCompleClass.Autocomplete();
            txtruc.AutoCompleteCustomSource = AutoCompleClass.AutocompleteRUCCliente();
            txtdni.AutoCompleteCustomSource = AutoCompleClass.AutocompleteDNI();
            if (!string.IsNullOrEmpty(xcliente.xClienteNP))
            {
                txtcliente.Text = xcliente.xClienteNP;
                traerDatos();
            }
            else
            {
                txtcliente.Text = "PUBLICO GENERAL";
                lblidclien.Text = "1";
                txtcliente.SelectionStart = txtcliente.Text.Length;
                txtcliente.Focus();
            }
        }
        private void btncliente_Click(object sender, EventArgs e)
        {
            abrirCliente();
        }
        private void txtcliente_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 13)
            {
                traerDatos();
            }
        }
        public void buscarTexto()
        {
            gvpanel.DataSource = null;
            if (cmdfiltrar.Text == "NUMERO") buscarNumero();
            else if (cmdfiltrar.Text == "DOCUMENTO") buscarDocumento();
            else if (cmdfiltrar.Text == "FORMAPAGO") buscarForma();
            else if (cmdfiltrar.Text == "VENDEDOR") buscarUsuario();
            else if (cmdfiltrar.Text == "ESTADO") buscarEstado();
            else if (cmdfiltrar.Text == "CONDICION") buscarCondicion();
            else if (cmdfiltrar.Text == "RUC") buscarRUC();
            else if (cmdfiltrar.Text == "DNI") buscarDNI();
            else if (cmdfiltrar.Text == "ENTREGA") buscarEntrega();
            else buscarCliente();
            ocultarColumnas();
        }
        private void txtbuscar_TextChanged(object sender, EventArgs e)
        {
            buscarTexto();
        }
        private void linklistar_Click(object sender, EventArgs e)
        {
            listar();
        }
        private void linkbuscar_Click(object sender, EventArgs e)
        {
            listarFecha();
            buscarTexto();
            gvpanel.Focus();
        }
        private void txtruc_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 13)traerRUC();
            else if (e.KeyCode == Keys.ShiftKey)txtcliente.Focus();
        }
        private void txtdni_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 13)traerDNI();
            else if (e.KeyCode == Keys.ShiftKey)txtruc.Focus();
        }
        private void FrmNotaPedido_KeyDown(object sender, KeyEventArgs e)
        {
            if (Convert.ToInt32(e.KeyData) == Convert.ToInt32(Keys.Control) + Convert.ToInt32(Keys.P))
            {
                if (btnimprimir.Enabled == true) controlPrint();
                else men.activeCajas();
            }
            else if (Convert.ToInt32(e.KeyData) == Convert.ToInt32(Keys.Control) + Convert.ToInt32(Keys.G))
            {
                if (btnguardar.Enabled == true)
                {
                    xAvisoPrint = 0;
                    validaServicio();
                }
                else
                {
                    if (btneditar.Enabled == false)
                        MessageBox.Show("Active las cajas para poder editar los datos o presione(Ctr + A)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    else
                        editaServicio();
                }
            }
            else if (Convert.ToInt32(e.KeyData) == Convert.ToInt32(Keys.Control) + Convert.ToInt32(Keys.A))
            {
                botonActivar();
            }
            else if (Convert.ToInt32(e.KeyData) == Convert.ToInt32(Keys.Control) + Convert.ToInt32(Keys.N))
            {
                limpiar();
            }
            else if (Convert.ToInt32(e.KeyData) == Convert.ToInt32(Keys.Control) + Convert.ToInt32(Keys.L))
            {
                this.metroTabControl1.SelectedIndex = 1;
                txtbuscar.Text = "";
                txtbuscar.Focus();
            }
            else if (e.KeyCode == Keys.Escape)
            {
                if (btnguardar.Enabled == true)
                {
                    gvproducto.DataSource = null;
                    gvproducto.Visible = false;
                    gvlista.Focus();
                }
                else
                {
                    if (btneditar.Enabled == false)
                    {
                        this.metroTabControl1.SelectedIndex = 1;
                        gvpanel.Focus();
                    }
                    else if (btneditar.Enabled == true)
                    {
                        gvproducto.Visible = false;
                        gvlista.Focus();
                    }
                }
            }
            else if (e.KeyCode == Keys.Insert)
            {
                chkLlevar.Checked = true;
                chkbuscar.Checked =true;
                if (lblestado.Text != "PENDIENTE")cmdsublinea.Enabled = false;
                else cmdsublinea.Enabled = true;
                lbldesci.Text = "Descripcion:";
                gvproducto.Visible = false;
                cmdsublinea.Text = "TODOS";
                txtcodigo.Text = "";
                txtcodigo.Focus();
            }
            else if (e.KeyCode == Keys.F5)
            {
                listar();
            }
            else if (e.KeyCode == Keys.F11)
            {
                string xestado, xnroguias;
                DataTable datos = objpedido.traerGuia(lblidnota.Text);
                if (datos.Rows.Count == 0)
                {
                    xestado = "PENDIENTE";
                    xnroguias = "0";
                }
                else
                {
                    xestado = datos.Rows[0][1].ToString();
                    xnroguias = datos.Rows[0][2].ToString();
                }
                if (int.Parse(xnroguias) == 0)
                {
                    if (xestado == "PENDIENTE")
                        editarTodoA();
                    else
                        MessageBox.Show("No puedes editar el item seleccionado porque el documento ya esta (cancelado o emitido)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    MessageBox.Show("No puedes editar el item seleccionado porque este documento ya tiene guias de salidas registradas", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            else if (e.KeyCode == Keys.F12)
            {
                string xestado, xnroguias;
                DataTable datos = objpedido.traerGuia(lblidnota.Text);
                if (datos.Rows.Count == 0)
                {
                    xestado = "PENDIENTE";
                    xnroguias = "0";
                }
                else
                {
                    xestado = datos.Rows[0][1].ToString();
                    xnroguias = datos.Rows[0][2].ToString();
                }
                if (int.Parse(xnroguias) == 0)
                {
                    if (xestado == "PENDIENTE")
                        editarTodoB();
                    else
                        MessageBox.Show("No puedes editar el item seleccionado porque el documento ya esta (cancelado o emitido)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    MessageBox.Show("No puedes editar el item seleccionado porque este documento ya tiene guias de salidas registradas", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
        }
        private void chkbuscar_CheckedChanged(object sender, EventArgs e)
        {
            if (chkbuscar.Checked == true)
            {
                cmdsublinea.Enabled = true;
                lbldesci.Text = "Descripcion:";
                gvproducto.Visible = false;
                txtcodigo.Text = "";
                txtcodigo.Focus();
            }
            else
            {
                cmdsublinea.Enabled = false;
                cmdsublinea.Text = "TODOS";
                lbldesci.Text = "Codigo:";
                gvproducto.Visible = false;
                txtcodigo.Text = "";
                txtcodigo.Focus();
            }
        }
        public bool buscarPDescripcion(EListaProducto xproducto)
        {
            return (xproducto.Descripcion.ToUpper().Contains(txtcodigo.Text.ToUpper()));
        }
        public void buscarDescripcion()
        {
            Predicate<EListaProducto> pre = new Predicate<EListaProducto>(buscarPDescripcion);
            gvproducto.DataSource = objetopro.FindAll(pre);
        }
        private void txtcodigo_TextChanged(object sender, EventArgs e)
        {
            if (cmdsublinea.Text == "TODOS")
            {
                if (chkbuscar.Checked ==true)
                {
                    if (txtcodigo.Text.Length == 0)
                    {
                        gvproducto.Visible = false;
                        gvproducto.DataSource = null;
                    }
                    else
                    {
                        gvproducto.Visible = true;
                        if (txtcodigo.Text.Length == 0)gvproducto.DataSource = null;
                        else buscarProducto();
                    }
                }
            }
            else
            {
                if (chkbuscar.Checked == false)
                {
                    //
                }
                else
                {
                    buscarDescripcion();
                }
            } 
        }
        private void gvproducto_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            if (gvproducto.CurrentCell.ColumnIndex ==4)
            {
                TextBox texto = e.Control as TextBox;
                if (texto != null)
                {
                    texto.KeyPress -= new KeyPressEventHandler(dgv);
                    texto.KeyPress += new KeyPressEventHandler(dgv);
                }
            }
        }
        private void gvproducto_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true;
            }
            else
            {
                if (e.KeyCode == Keys.Delete) eliminarB();
                else if (e.KeyCode == Keys.ShiftKey) txtcodigo.Focus();
            }
        }
        FrmDocumento xdocu;
        public void solicitarDatos()
        {
            if (gvpanel.Rows.Count > 0)
            {
                chkbuscar.Checked = false;
                this.lblidnota.Text = Convert.ToString(gvpanel.CurrentRow.Cells[3].Value);
                this.cmddocumento.Text = Convert.ToString(gvpanel.CurrentRow.Cells[4].Value);
                this.lblemitido.Text = Convert.ToString(gvpanel.CurrentRow.Cells[5].Value);
                this.lblidclien.Text = Convert.ToString(gvpanel.CurrentRow.Cells[6].Value);
                this.txtcliente.Text = Convert.ToString(gvpanel.CurrentRow.Cells[7].Value);
                this.txtruc.Text = Convert.ToString(gvpanel.CurrentRow.Cells[8].Value);
                this.txtdni.Text = Convert.ToString(gvpanel.CurrentRow.Cells[9].Value);
                this.cmdcondicion.Text = Convert.ToString(gvpanel.CurrentRow.Cells[10].Value);
                this.cmdforma.Text = Convert.ToString(gvpanel.CurrentRow.Cells[11].Value);
                //this.txtdias.Text = Convert.ToString(gvpanel.CurrentRow.Cells[12].Value);
                this.detimepago.Text = Convert.ToString(gvpanel.CurrentRow.Cells[13].Value);
                this.lblsubtotal.Text = Convert.ToString(gvpanel.CurrentRow.Cells[17].Value);
                this.txtmovilidad.Text = Convert.ToString(gvpanel.CurrentRow.Cells[18].Value);
                this.txtdescuento.Text = Convert.ToString(gvpanel.CurrentRow.Cells[19].Value);
                this.lbltotal.Text = Convert.ToString(gvpanel.CurrentRow.Cells[20].Value);
                this.txtacuenta.Text = Convert.ToString(gvpanel.CurrentRow.Cells[16].Value);
                this.lblsaldo.Text = Convert.ToString(gvpanel.CurrentRow.Cells[15].Value);
                this.lbladicional.Text = Convert.ToString(gvpanel.CurrentRow.Cells[21].Value);
                this.lbltotalTarjeta.Text = Convert.ToString(gvpanel.CurrentRow.Cells[22].Value);
                this.lbltotalpagar.Text = Convert.ToString(gvpanel.CurrentRow.Cells[14].Value);
                this.lblvendedor.Text = Convert.ToString(gvpanel.CurrentRow.Cells[23].Value);
                this.lblestado.Text = Convert.ToString(gvpanel.CurrentRow.Cells[24].Value);
                this.cmdcompania.Text = Convert.ToString(gvpanel.CurrentRow.Cells[25].Value);
                this.txtfiscal.Text = Convert.ToString(gvpanel.CurrentRow.Cells[26].Value);
                this.txtdespacho.Text = Convert.ToString(gvpanel.CurrentRow.Cells[27].Value);
                this.txttelefono.Text = Convert.ToString(gvpanel.CurrentRow.Cells[28].Value);
                this.cmdentrega.Text = Convert.ToString(gvpanel.CurrentRow.Cells[29].Value);
                this.lblmodifica.Text = Convert.ToString(gvpanel.CurrentRow.Cells[30].Value);
                this.lblfechaMod.Text = Convert.ToString(gvpanel.CurrentRow.Cells[31].Value);
                this.cmdconcepto.Text = Convert.ToString(gvpanel.CurrentRow.Cells[32].Value);
                this.lblserie.Text = Convert.ToString(gvpanel.CurrentRow.Cells[33].Value);
                this.txtnrodoc.Text = Convert.ToString(gvpanel.CurrentRow.Cells[34].Value);
                this.txtefectivo.Text = Convert.ToString(gvpanel.CurrentRow.Cells[35].Value);
                this.lblvuelto.Text = Convert.ToString(gvpanel.CurrentRow.Cells[36].Value);
                btnimprimir.Enabled = false;
                gvlista.DataSource = null;
                btnguardar.Enabled = false;
                btneditar.Enabled = false;
                btneliminar.Enabled = false;
                btnactivar.Enabled = true;
                btncopia.Enabled = true;
                desactivarCajas();
                gvproducto.Visible = false;
                txtcodigo.Text = "";
                lbldesci.Text = "Descripcion:";
                listaRe.Items.Clear();
                listaReB.DataSource = null;
                listarB();
                this.metroTabControl1.SelectedIndex = 0;
            }
        }
        private void gvpanel_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (e.KeyCode == Keys.Enter)
                {
                    if (gvpanel.Rows.Count > 0)
                    {
                        if (gvpanel.CurrentCell.ColumnIndex == 0)
                        {
                            e.SuppressKeyPress = true;
                            solicitarDatos();
                        }
                        else if (gvpanel.CurrentCell.ColumnIndex == 2)
                        {
                            e.SuppressKeyPress = true;
                            if (Convert.ToString(gvpanel.CurrentRow.Cells[4].Value) == "FACTURA")
                            {
                                xdocu = new FrmDocumento();
                                xdocu.xid = Convert.ToString(gvpanel.CurrentRow.Cells[3].Value);
                                xdocu.xdocumento = Convert.ToString(gvpanel.CurrentRow.Cells[4].Value);
                                xdocu.xcliente = Convert.ToString(gvpanel.CurrentRow.Cells[7].Value);
                                xdocu.xcondicion = Convert.ToString(gvpanel.CurrentRow.Cells[10].Value);
                                xdocu.xFormaPago = Convert.ToString(gvpanel.CurrentRow.Cells[11].Value);
                                xdocu.xmovilidad = Convert.ToString(gvpanel.CurrentRow.Cells[18].Value);
                                xdocu.xdescuento = Convert.ToString(gvpanel.CurrentRow.Cells[19].Value);
                                xdocu.xadicional = Convert.ToString(gvpanel.CurrentRow.Cells[21].Value);
                                xdocu.xEstado = Convert.ToString(gvpanel.CurrentRow.Cells[24].Value);
                                xdocu.xCompania = Convert.ToString(gvpanel.CurrentRow.Cells[25].Value);
                                xdocu.xEfectivo = Convert.ToString(gvpanel.CurrentRow.Cells[34].Value);
                                xdocu.xVuelto = Convert.ToString(gvpanel.CurrentRow.Cells[35].Value);
                                xdocu.xIGV = xIGV;
                                xdocu.ShowDialog();
                                int pos = bs.Position;
                                if (txtbuscar.Text.Length == 0)
                                {
                                    listar();
                                    if (gvpanel.Rows.Count > 0) gvpanel.CurrentCell = gvpanel.CurrentRow.Cells[2];
                                    bs.Position = pos;
                                }
                                else
                                {
                                    listar();
                                    buscarTexto();
                                    if (gvpanel.Rows.Count > 0) gvpanel.CurrentCell = gvpanel.CurrentRow.Cells[2];
                                    bs.Position = pos;
                                }
                            }
                            else
                            {
                                MessageBox.Show("Seleccione solo Factura para imprimir,enviar a SUNAT", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            }
                        }
                        else if (gvpanel.CurrentCell.ColumnIndex == 15)
                        {
                            e.SuppressKeyPress = true;
                            if (Convert.ToString(gvpanel.CurrentRow.Cells[4].Value) == "PROFORMA")
                            {
                                MessageBox.Show("Las proformas no tienen liquidaciones de pago.", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            }
                            else
                            {
                                KardexVenta xkardex;
                                xkardex = new KardexVenta();
                                xkardex.xidnota = Convert.ToString(gvpanel.CurrentRow.Cells[3].Value);
                                xkardex.xDocumento = Convert.ToString(gvpanel.CurrentRow.Cells[4].Value);
                                xkardex.xcliente = Convert.ToString(gvpanel.CurrentRow.Cells[7].Value);
                                xkardex.xCondicion = Convert.ToString(gvpanel.CurrentRow.Cells[10].Value);
                                xkardex.xtotal = Convert.ToString(gvpanel.CurrentRow.Cells[14].Value);
                                xkardex.xvendedor = Convert.ToString(gvpanel.CurrentRow.Cells[23].Value);
                                xkardex.xNroDoocu = Convert.ToString(gvpanel.CurrentRow.Cells[33].Value) + "-" + Convert.ToString(gvpanel.CurrentRow.Cells[34].Value);
                                xkardex.ShowDialog();
                            }
                        }
                    }
                }
                else if (e.KeyCode == Keys.ShiftKey)
                {
                    txtbuscar.Focus();
                }
            }
            catch (Exception ex) { ex.ToString(); }
        }
        public void validarFormaPago()
        {
            if (cmdforma.Text == "TARJETA")
            {
                txtefectivo.Enabled = false;
                txtefectivo.Text = lbltotalpagar.Text;
            }
            else if (cmdforma.Text == "DEPOSITO" || cmdforma.Text == "YAPE")
            {
                txtefectivo.Enabled = false;
                txtefectivo.Text = lbltotalpagar.Text;
            }
            else
            {
                txtefectivo.Enabled = true;
            }
        }
        public void botonInsertar()
        {
            string xestadoss = string.Empty;
            if (btnguardar.Enabled == true)
            {
                ingresarDetalle();
                validarFormaPago();
            }
            else if (btneditar.Enabled == true)
            {
                xestadoss = objpedido.traerEstado(lblidnota.Text);
                if (xestadoss.Contains("PENDIENTE")||xestadoss.Contains("ANULADO"))
                {
                    insertadetalleB();
                    validarFormaPago();
                }
                else
                    MessageBox.Show("No puedes Ingresar mas productos porque el documento ya esta (cancelado o emitido)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
        private void gvproducto_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (gvproducto.CurrentCell.ColumnIndex == 4)
                {
                    if (gvproducto.CurrentRow.Cells[4].Value == null || Convert.ToString(gvproducto.CurrentRow.Cells[4].Value) == "")
                        lblidclien.Visible = false;
                    else if (Convert.ToDecimal(gvproducto.CurrentRow.Cells[4].Value) != 0)
                        botonInsertar();
                }
            }
            catch (Exception ex) { ex.ToString(); MessageBox.Show("Ingrese Correctamente el Numero", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Error); gvproducto.CurrentRow.Cells[4].Value = ""; }
        }
        public void validarImpresion()
        {
            if (cmdentrega.SelectedItem == null)
            {
                MessageBox.Show("Seleccione la forma de Entrega(IMMEDIATA O POR ENTREGAR)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                cmdentrega.Focus();
            }
            else if (cmdentrega.Text == "POR ENTREGAR" && lblidclien.Text == "1")
            {
                MessageBox.Show("Si la Entrega es (POR ENTREGAR) el cliente no puede ser PUBLICO GENERAL...favor de seleccionar o registrar sus datos del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtcliente.Focus();
            }
            else if (cmddocumento.Text == "BOLETA" && cmdforma.Text != "EFECTIVO")
            {
                if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8 ||double.Parse(lbltotalpagar.Text) <= 0)
                {
                    MessageBox.Show("Si la forma de pago es con Tarjeta o Deposito favor de ingresar los siguientes datos:" + "\n" +
                  "1. Nombre completo del cliente" + "\n" + "2. DNI y/o RUC (DNI en el caso de Boleta,RUC en el caso de Factura)", 
                  "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    if (txtnrodoc.Text.Length < 8)
                    {
                        MessageBox.Show("El numero de boleta no puede ser menor a ocho digitos...Favor de verificar el numero correlativo", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        txtnrodoc.SelectionStart = txtnrodoc.Text.Length;
                        txtnrodoc.Focus();
                    }
                    else
                    {
                        BarraBoleta();
                    }
                }
            }
            else if (cmddocumento.Text == "PROFORMA V" && cmdforma.Text != "EFECTIVO")
            {
                if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                    men.datosVacios();
                else
                    BarraTiket();
            }
            else
            {
                if (cmddocumento.SelectedItem == null || cmdcondicion.SelectedItem == null || cmdforma.SelectedItem == null)
                {
                    men.SeleccioneUnDato();
                    cmddocumento.Focus();
                }
                else if (cmddocumento.Text == "BOLETA")
                {
                    if (txtnrodoc.Text.Length < 8 )
                    {
                        MessageBox.Show("El numero de boleta no puede ser menor a ocho digitos...Favor de verificar el numero correlativo", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        txtnrodoc.SelectionStart = txtnrodoc.Text.Length;
                        txtnrodoc.Focus();
                    }
                    else
                    {
                        if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotal.Text) < 500)
                        {
                            if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0) men.datosVacios();
                            else BarraBoleta();
                        }
                        else if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotal.Text) >= 500)
                        {
                            if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8|| txtfiscal.Text.Length == 0||double.Parse(lbltotalpagar.Text) <= 0)
                                MessageBox.Show("El monto de la Boleta supera los 500.00 soles...ingresar su DNI y Direccion porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            else
                                BarraBoleta();
                        }
                    }
                }
                else
                {
                    if (cmddocumento.Text == "FACTURA")
                    {
                        if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtruc.Text.Length < 8 || txtfiscal.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                            MessageBox.Show("Si selecciono Factura favor de ingresar su (Razon Social,RUC y Direccion)...", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        else
                            BarraTiket();
                    }
                    else
                    {
                        if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0) men.datosVacios();
                        else BarraTiket();
                    }
                }
            }
        }
        public void editaBarra()
        {
            descuentos();
            if (txtefectivo.Text.Length == 0)
            {
                MessageBox.Show("Ingrese el efectivo que le dio el cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(txtefectivo.Text) < decimal.Parse(lbltotalpagar.Text))
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(lblvuelto.Text) < 0)
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else
            {
                xPersonal = xUsuario.ToString();
                editadetalle();
            }
        }
        public void BarraTiket()
        {
            descuentos();
            if (txtefectivo.Text.Length == 0)
            {
                MessageBox.Show("Ingrese el efectivo que le dio el cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(txtefectivo.Text) < decimal.Parse(lbltotalpagar.Text))
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(lblvuelto.Text) < 0)
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else
            {
                xPersonal = xUsuario.ToString();
                if (btnguardar.Enabled == true) guardar();
                else if (btneditar.Enabled == true) editadetalle();
                else imprimir();
            }
        }
        public void BarraBoleta()
        {
            descuentos();
            if (txtefectivo.Text.Length == 0)
            {
                MessageBox.Show("Ingrese el efectivo que le dio el cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(txtefectivo.Text) < decimal.Parse(lbltotalpagar.Text))
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(lblvuelto.Text) < 0)
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else
            {
                xPersonal = xUsuario.ToString();
                if (btnguardar.Enabled == true) guardar();
                else if (btneditar.Enabled == true) editadetalle();
            }
        }
        public void validarVuelto()
        {
            descuentos();
            if (txtefectivo.Text.Length == 0)
            {
                MessageBox.Show("Ingrese el efectivo que le dio el cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(txtefectivo.Text) < decimal.Parse(lbltotalpagar.Text))
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else if (decimal.Parse(lblvuelto.Text) < 0)
            {
                MessageBox.Show("El vuelto no puede ser menor a cero...verificar el efectivo porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtefectivo.Focus();
            }
            else
            {
                xPersonal = xUsuario.ToString();
                guardar();
            }
        }
        public void validaGuardado()
        {
            if (cmdentrega.Text == "POR ENTREGAR" && lblidclien.Text == "1")
            {
                MessageBox.Show("Si la Entrega es (POR ENTREGAR) el cliente no puede ser PUBLICO GENERAL...favor de seleccionar o registrar sus datos del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtcliente.Focus();
            }
            else if ((cmddocumento.Text == "BOLETA") && cmdforma.Text != "EFECTIVO")
            {
                if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8 ||double.Parse(lbltotalpagar.Text) <= 0)
                    MessageBox.Show("Si la forma de pago es con Tarjeta o Deposito favor de ingresar los siguientes datos:" + "\n" +
                   "1. Nombre completo del cliente" + "\n" + "2. DNI y/o RUC (DNI en el caso de Boleta,RUC en el caso de Factura)", 
                   "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                    validarVuelto();
            }
            else
            {
                if (cmddocumento.SelectedItem == null || cmdcondicion.SelectedItem == null || cmdforma.SelectedItem == null)
                {
                    men.SeleccioneUnDato();
                    cmddocumento.Focus();
                }
                else if (cmddocumento.Text == "FACTURA")
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtruc.Text.Length < 11 || txtfiscal.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                    {
                        MessageBox.Show("Si selecciono Factura favor de ingresar su (Razon Social,RUC y Direccion)...", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        txtcliente.Focus();
                    }
                    else
                    {
                        validarVuelto();
                    }
                }
                else if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotalpagar.Text) < 500)
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0) men.datosVacios();
                    else
                    {
                        validarVuelto();
                    }
                }
                else if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotalpagar.Text) >= 500)
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8 || txtfiscal.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                        MessageBox.Show("El monto de la Boleta supera los 500.00 soles...ingresar su DNI y Direccion porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    else validarVuelto();
                }
                else
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                        men.datosVacios();
                    else
                    {
                        validarVuelto();
                    }
                }
            }
        }
        public void validaServicio()
        {
            if (cmddocumento.ComboBox.SelectedValue.Equals("03"))
            {
                MessageBox.Show("Si selecciono una Boleta solo se puede Imprimir(Ctrl + P)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else if (cmddocumento.ComboBox.SelectedValue.Equals("00"))
            {
                MessageBox.Show("Si selecciono una PROFORMA V solo se puede Imprimir(Ctrl + P)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                if (txtnrodoc.Text.Length < 8)
                {
                    MessageBox.Show("El numero de documento no puede ser menor a ocho digitos...Favor de verificar el numero correlativo", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtnrodoc.SelectionStart = txtnrodoc.Text.Length;
                    txtnrodoc.Focus();
                }
                else if (cmdcondicion.Text == "CREDITO" && lblidclien.Text == "1")
                {
                    MessageBox.Show("Si el documento es a Credito favor de ingresar el nombre completo del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtcliente.Focus();
                }
                else if (cmdcondicion.Text == "CREDITO" && cmdentrega.Text != "POR ENTREGAR")
                {
                    MessageBox.Show("Si el documento es a Credito... la entrega debe ser(Por Entregar)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtcliente.Focus();
                }
                else
                {
                    if (cmdconcepto.Text == "MERCADERIA")
                    {
                        validaGuardado();
                    }
                    else
                    {
                        if (cmddocumento.Text == "PROFORMA V")
                        {
                            MessageBox.Show("Si el documento es de servicio...deve ser solo Boleta o Factura", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            cmddocumento.Text = "BOLETA";
                            cmddocumento.Focus();
                        }
                        else
                        {
                            validaGuardado();
                        }
                    }
                }
            }
        }
        public void validaImprimeA()
        {
            if (cmdcondicion.Text == "CREDITO" && lblidclien.Text == "1")
            {
                MessageBox.Show("Si el documento es a Credito favor de ingresar el nombre completo del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtcliente.Focus();
            }
            else if (cmdcondicion.Text == "CREDITO" && cmdentrega.Text != "POR ENTREGAR")
            {
                MessageBox.Show("Si el documento es a Credito... la entrega debe ser(Por Entregar)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtcliente.Focus();
            }
            else
            {
                if (cmdentrega.Text == "POR GUIA SALIDA")
                {
                    MessageBox.Show("Cuando es POR GUIA SALIDA,solo se permitira guardar para imprimir en una factura", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    if (cmdconcepto.Text == "MERCADERIA")
                    {
                        validarImpresion();
                    }
                    else
                    {
                        if (cmddocumento.Text == "PROFORMA V")
                        {
                            MessageBox.Show("Si el documento es de servicio...deve ser solo Boleta o Factura", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            cmddocumento.Text = "BOLETA";
                            cmddocumento.Focus();
                        }
                        else
                        {
                            validarImpresion();
                        }
                    }
                }
            }
        }
        public void validarBoleta()
        {
            if (cmdconcepto.Text.Contains("SERVICIO") || cmdconcepto.Text.Contains("CONTINGENCIA"))
            {
                if (cmddocumento.Text == "PROFORMA" || cmddocumento.Text == "PROFORMA V")
                    cmddocumento.Text = "BOLETA";
            }
            if (cmdconcepto.Text.Contains("CONTINGENCIA"))
            {
                lblserie.Text = "0001";
                txtnrodoc.Text = "00000001";
            }
            else
            {
                if (cmddocumento.Text == "BOLETA") lblserie.Text = xSerieBoleta;
                else if (cmddocumento.Text == "FACTURA") lblserie.Text = "F001";
                else lblserie.Text = "0001";
                txtnrodoc.Text = "00000001";
            }
        }
        public void botonEliminar()
        {
            xPersonal = string.Empty;
            DialogResult resul = new DialogResult();
            resul = MessageBox.Show("Esta seguro que Desea eliminar el Documento Seleccionado?", "ELIMINAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (resul == DialogResult.OK)
            {
                xPersonal = txtvendedor.Text;
                eliminarPedido();
            }
        }
        public void botonActivar()
        {
            if (btnactivar.Enabled ==true)
            {
                string xestado, xnroguias, xemitidos, xacuentas = string.Empty;
                DataTable datos = objpedido.traerGuia(lblidnota.Text);
                if (datos.Rows.Count == 0)
                {
                    xestado = "PENDIENTE";
                    xnroguias = "0";
                    xemitidos = "0";
                    xacuentas = "0";
                }
                else
                {
                    xestado = datos.Rows[0][1].ToString();
                    xnroguias = datos.Rows[0][2].ToString();
                    xemitidos = datos.Rows[0][3].ToString();
                    xacuentas = datos.Rows[0][4].ToString();
                }
                if (xestado.Contains("ANULADO"))
                {
                    DialogResult resul = new DialogResult();
                    resul = MessageBox.Show("Al activar las cajas alteraras los datos registrados... en realidad deseas modificar los datos", "EDITAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                    if (resul == DialogResult.OK)
                    {
                        activarCajas();
                        btnimprimir.Enabled = true;
                        btnactivar.Enabled = false;
                        btneditar.Enabled = true;
                        btneliminar.Enabled = true;
                        gvlista.Columns[6].ReadOnly = true;
                        gvlista.Columns[9].ReadOnly = true;
                        gvlista.Columns[10].ReadOnly = true;
                        gvlista.Columns[11].ReadOnly = true;
                    }
                }
                else
                {
                    if (int.Parse(xacuentas) >= 1)
                    {
                        MessageBox.Show("El documento no puede ser editado porque ya tiene una liquidacion de pago", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                    else if (xemitidos != "0" && (cmddocumento.Text != "PROFORMA"))
                    {
                        MessageBox.Show("El documento no puede ser editado porque ya ha sido canjeado por(Boleta y/o Factura)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                    else if (int.Parse(xnroguias) > 0)
                    {
                        DialogResult resul = new DialogResult();
                        resul = MessageBox.Show("Al activar las cajas alteraras los datos registrados... en realidad deseas modificar los datos", "EDITAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                        if (resul == DialogResult.OK)
                        {
                            cmddocumento.Enabled = true;
                            btncliente.Enabled = true;
                            txtcliente.Enabled = true;
                            txtruc.Enabled = true;
                            txtdni.Enabled = true;
                            btnimprimir.Enabled = true;
                            btnactivar.Enabled = false;
                            btneditar.Enabled = true;
                        }
                    }
                    else
                    {
                        if (xestado == "CANCELADO" || xestado == "ACUENTA")
                        {
                            DialogResult resul = new DialogResult();
                            resul = MessageBox.Show("Al activar las cajas alteraras los datos registrados... en realidad deseas modificar los datos", "EDITAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                            if (resul == DialogResult.OK)
                            {
                                cmddocumento.Enabled = true;
                                btncliente.Enabled = true;
                                txtcliente.Enabled = true;
                                txtruc.Enabled = true;
                                txtdni.Enabled = true;
                                btnimprimir.Enabled = true;
                                btnactivar.Enabled = false;
                                btneditar.Enabled = true;
                            }
                        }
                        else
                        {
                            DialogResult resul = new DialogResult();
                            resul = MessageBox.Show("Al activar las cajas alteraras los datos registrados... en realidad deseas modificar los datos", "EDITAR", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
                            if (resul == DialogResult.OK)
                            {
                                if (cmdentrega.Text == "POR GUIA SALIDA")
                                {
                                    cmddocumento.Enabled = true;
                                    btncliente.Enabled = true;
                                    txtcliente.Enabled = true;
                                    txtruc.Enabled = true;
                                    txtdni.Enabled = true;
                                    btnimprimir.Enabled = true;
                                    btnactivar.Enabled = false;
                                    btneditar.Enabled = true;
                                    btneliminar.Enabled = true;
                                }
                                else
                                {
                                    activarCajas();
                                    btnimprimir.Enabled = true;
                                    btnactivar.Enabled = false;
                                    btneditar.Enabled = true;
                                    btneliminar.Enabled = true;
                                    gvlista.Columns[6].ReadOnly = true;
                                    gvlista.Columns[9].ReadOnly = true;
                                    gvlista.Columns[10].ReadOnly = true;
                                    gvlista.Columns[11].ReadOnly = true;
                                    chkLlevar.Enabled = false;
                                    cmdMesas.Enabled = false;
                                    txtcodigo.Enabled = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        public void validarEditado()
        {
            if (cmdentrega.SelectedItem == null)
            {
                MessageBox.Show("Seleccione la forma de Entrega(IMMEDIATA O POR ENTREGAR)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                cmdentrega.Focus();
            }
            else if (cmdentrega.Text == "POR ENTREGAR" && lblidclien.Text == "")
            {
                MessageBox.Show("Si la Entrega es (POR ENTREGAR) el cliente no puede ser PUBLICO GENERAL...favor de seleccionar o registrar sus datos del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtcliente.Focus();
            }
            else if (cmddocumento.Text == "BOLETA" && cmdforma.Text != "EFECTIVO")
            {
                if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8 ||double.Parse(lbltotalpagar.Text) <= 0)
                    MessageBox.Show("Si la forma de pago es con Tarjeta o Deposito favor de ingresar los siguientes datos:" + "\n" +
                   "1. Nombre completo del cliente" + "\n" + "2. DNI y/o RUC (DNI en el caso de Boleta,RUC en el caso de Factura)", 
                   "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                    editaBarra();
            }
            else if (cmddocumento.Text == "PROFORMA V" && cmdforma.Text != "EFECTIVO")
            {
                if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0||double.Parse(lbltotalpagar.Text) <= 0)
                {
                    men.datosVacios();
                }
                else
                {
                    editaBarra();
                }
            }
            else
            {
                if (cmddocumento.SelectedItem == null || cmdcondicion.SelectedItem == null || cmdforma.SelectedItem == null)
                {
                    men.SeleccioneUnDato();
                    cmddocumento.Focus();
                }
                else if (cmddocumento.Text == "FACTURA")
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtruc.Text.Length < 8 || txtfiscal.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                        MessageBox.Show("Si selecciono Factura favor de ingresar su (Razon Social,RUC y Direccion)...", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    else
                        editaBarra();
                }
                else if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotal.Text) < 500)
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0) men.datosVacios();
                    else editaBarra();
                }
                else if (cmddocumento.Text == "BOLETA" && decimal.Parse(lbltotal.Text) >= 500)
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || txtdni.Text.Length < 8 || txtfiscal.Text.Length == 0 || gvlista.Rows.Count <= 0)
                        MessageBox.Show("El monto de la Boleta supera los 500.00 soles...ingresar su DNI y Direccion porfavor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    else
                        editaBarra();
                }
                else
                {
                    if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || double.Parse(lbltotalpagar.Text) <= 0)
                        men.datosVacios();
                    else
                        editaBarra();
                }
            }
        }
        public void editaServicio()
        {
            if (cmddocumento.ComboBox.SelectedValue.Equals("03"))
            {
                MessageBox.Show("Si selecciono una Boleta solo se puede Imprimir(Ctrl + P)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else if (cmddocumento.ComboBox.SelectedValue.Equals("00"))
            {
                MessageBox.Show("Si selecciono una PROFORMA V solo se puede Imprimir(Ctrl + P)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                if (cmddocumento.Text == "PROFORMA" && cmdcondicion.Text == "CREDITO")
                {
                    MessageBox.Show("Una proforma no puede ser emitida a credito", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtcliente.Focus();
                }
                else if (cmdcondicion.Text == "CREDITO" && lblidclien.Text == "1")
                {
                    MessageBox.Show("Si el documento es a Credito favor de ingresar el nombre completo del cliente", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtcliente.Focus();
                }
                else if (cmdcondicion.Text == "CREDITO" && cmdentrega.Text != "POR ENTREGAR")
                {
                    MessageBox.Show("Si el documento es a Credito... la entrega debe ser(Por Entregar)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtcliente.Focus();
                }
                else
                {
                    if (cmdconcepto.Text == "MERCADERIA")
                    {
                        validarEditado();
                    }
                    else
                    {
                        if (cmddocumento.Text == "PROFORMA" || cmddocumento.Text == "PROFORMA V")
                        {
                            MessageBox.Show("Si el documento es de servicio...deve ser solo Boleta o Factura", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            cmddocumento.Text = "BOLETA";
                            cmddocumento.Focus();
                        }
                        else
                        {
                            validarEditado();
                        }
                    }
                }
            }
        }
        private void txtbuscar_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                gvpanel.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txtbuscar_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up)cmdfiltrar.Focus();
        }
        private void gvpanel_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            try
            {
                if (gvpanel.Rows.Count > 0)
                {
                    int count;
                    for (count = 0; count < gvpanel.Rows.Count; count++)
                    {
                        if (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "ANULADO")
                        {
                            gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.LightCoral;
                        }
                        else
                        {
                            if (Convert.ToString(gvpanel.Rows[count].Cells[32].Value) == "SERVICIO")
                            {
                                gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(255, 192, 255);
                            }
                            else
                            {
                                if (Convert.ToString(gvpanel.Rows[count].Cells[4].Value) == "PROFORMA")
                                    gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.Silver;
                                else
                                {
                                    if (Convert.ToString(gvpanel.Rows[count].Cells[29].Value) == "POR ENTREGAR" && (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "PENDIENTE"))
                                        gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.Lime;
                                    else if (Convert.ToString(gvpanel.Rows[count].Cells[29].Value) == "POR ENTREGAR" && (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "ACUENTA"))
                                        gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.Aquamarine;
                                    else if (Convert.ToString(gvpanel.Rows[count].Cells[29].Value) == "POR ENTREGAR" && (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "CANCELADO"))
                                        gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.White;
                                    else
                                    {
                                        if (Convert.ToString(gvpanel.Rows[count].Cells[10].Value) == "CREDITO" && Convert.ToString(gvpanel.Rows[count].Cells[24].Value) != "CANCELADO")
                                            gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.Orange;
                                        else if (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "ACUENTA")
                                            gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.Yellow;
                                        else
                                        {
                                            if (Convert.ToString(gvpanel.Rows[count].Cells[24].Value) == "CANCELADO")
                                                gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.White;
                                            else
                                                gvpanel.Rows[count].DefaultCellStyle.BackColor = System.Drawing.Color.SkyBlue;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }
        private void dtimeinicio_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                dtimefin.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void dtimefin_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                listarFecha();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void gvlista_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            try
            {
                foreach (DataGridViewRow row in gvlista.Rows)
                {
                    row.HeaderCell.Value = (row.Index + 1).ToString();
                }
            }
            catch (Exception ex) { ex.ToString(); }
        }
        private void cmdcondicion_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 13)
            {
                botoncondicion();
            }
            else if (e.KeyCode == Keys.ShiftKey)
            {
                if (txtnrodoc.Enabled == true)
                {
                    txtnrodoc.SelectionStart = txtnrodoc.Text.Length;
                    txtnrodoc.Focus();
                }
                else
                {
                    cmddocumento.Focus();
                }
            }
        }
        private void txtfiscal_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txtdespacho.SelectionStart = txtdespacho.Text.Length;
                txtdespacho.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txtdespacho_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txttelefono.Focus();
                txttelefono.SelectionStart = txttelefono.Text.Length;
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txttelefono_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txtmovilidad.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txtmovilidad_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                descuentos();
                txtdescuento.Focus();
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtmovilidad.Text.Length; i++)
            {
                if (txtmovilidad.Text[i] == '.')
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
        private void txtdescuento_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                descuentos();
                txtefectivo.Focus();
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtdescuento.Text.Length; i++)
            {
                if (txtdescuento.Text[i] == '.')
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
        private void txtacuenta_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                descuentos();
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtacuenta.Text.Length; i++)
            {
                if (txtacuenta.Text[i] == '.')
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
        private void txtacuenta_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)txtdescuento.Focus();
        }
        private void txtdescuento_KeyDown_1(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)txtmovilidad.Focus();
        }
        private void txtmovilidad_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)txttelefono.Focus();
        }
        public void botonforma()
        {
            if (cmdforma.Text == "TARJETA")
                lblporcentaje.Text = "Adic. 4.5%:";
            else
                lblporcentaje.Text = "Adic. 0.0%:";
            descuentos();
            if (cmdforma.Text == "TARJETA")
            {
                txtefectivo.Enabled = false;
                txtefectivo.Text = lbltotalpagar.Text;
                txtcliente.SelectionStart = txtcliente.Text.Length;
                txtcliente.Focus();
            }
            else if (cmdforma.Text == "DEPOSITO" || cmdforma.Text == "YAPE")
            {
                txtefectivo.Enabled = false;
                txtefectivo.Text = lbltotalpagar.Text;
                txtcliente.SelectionStart = txtcliente.Text.Length;
                txtcliente.Focus();
            }
            else
            {
                txtefectivo.Enabled = true;
                txtefectivo.Text = "";
                txtefectivo.SelectionStart = txtefectivo.Text.Length;
                txtefectivo.Focus();
            }
        }
        public void botoncondicion()
        {
            if (cmdcondicion.SelectedItem == null)
            {
                men.SeleccioneUnDato();
                cmdcondicion.Text = "";
                cmdcondicion.Focus();
            }
            else
            {
                if (cmdcondicion.Text == "CREDITO")
                {
                    detimepago.Enabled = true;
                }
                else
                {
                    detimepago.Enabled = false;
                }
                cmdforma.Focus();
                cmdforma.SelectionStart = cmdforma.Text.Length;
            }
        }
        private void detimepago_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)cmdentrega.Focus();
        }
        private void txttelefono_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up)txtdespacho.Focus();
        }
        private void txtfiscal_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)txtdni.Focus();
        }
        private void txtdespacho_TextChanged(object sender, EventArgs e)
        {
            txtdespacho.CharacterCasing = CharacterCasing.Upper;
        }
        private void txttelefono_TextChanged(object sender, EventArgs e)
        {
            txttelefono.CharacterCasing = CharacterCasing.Upper;
        }
        private void dtimefin_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)dtimeinicio.Focus();
        }
        private void btncopia_Click(object sender, EventArgs e)
        {
            if (cmddocumento.SelectedItem == null || cmdcondicion.SelectedItem == null || cmdforma.SelectedItem == null)
            {
                men.SeleccioneUnDato();
                cmddocumento.Focus();
            }
            if (lblidclien.Text.Length == 0 || txtcliente.Text.Length == 0 || gvlista.Rows.Count <= 0)
                men.datosVacios();
            else
            {
                xCopia = "Copia";
                imprimir();
                xCopia = string.Empty;
            }
        }
        private void gvproducto_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            if (gvproducto.Rows.Count >= 1)
            {
                try
                {
                    int count;
                    for (count = 0; count < gvproducto.Rows.Count; count++)
                    {
                        if (Convert.ToDecimal(gvproducto.Rows[count].Cells[5].Value) <= 0)
                            gvproducto.Rows[count].Cells[5].Style.ForeColor = System.Drawing.Color.Red;
                        else
                            if (Convert.ToDecimal(gvproducto.Rows[count].Cells[5].Value) <= Convert.ToDecimal(gvproducto.Rows[count].Cells[11].Value))
                                gvproducto.Rows[count].Cells[5].Style.ForeColor = System.Drawing.Color.Blue;
                            else
                                gvproducto.Rows[count].Cells[5].Style.ForeColor = System.Drawing.Color.Black;
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }
        private void FrmNotaPedido_FormClosing(object sender, FormClosingEventArgs e)
        {
            //try
            //{
            //    if (cliente != null && cliente.State.Equals(WebSocketState.Open))
            //        cliente.CloseAsync(WebSocketCloseStatus.Empty, "", CancellationToken.None);
            //}
            //catch (Exception ex) { ex.ToString(); }
        }
        //public async void enviar()
        //{
        //    try
        //    {
        //        string TexElimina = string.Empty;
        //        TexElimina = "Elimino el Docu Nro "+lblidnota.Text + " Monto S/ " + lbltotalpagar.Text;
        //        string mensaje = String.Format("{0}{1}|{2}|{3}", "_ ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexElimina);
        //        byte[] buffer = Encoding.Default.GetBytes(mensaje);
        //        ArraySegment<byte> data = new ArraySegment<byte>(buffer);
        //        await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
        //    }
        //    catch (Exception ex) { ex.ToString(); MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        //}
        //public async void enviarB(string codigo)
        //{
        //    try
        //    {
        //        string TexGuarda = string.Empty;
        //        TexGuarda = "Se Registro "+cmddocumento.Text+" Nro " + codigo.ToString() + " Monto S/ " + lbltotalpagar.Text;
        //        string mensaje = String.Format("{0}{1}|{2}|{3}", "- ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexGuarda);
        //        byte[] buffer = Encoding.Default.GetBytes(mensaje);
        //        ArraySegment<byte> data = new ArraySegment<byte>(buffer);
        //        await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
        //    }
        //    catch (Exception ex) {
        //        ex.ToString();
        //        MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        //    }
        //}
        //public async void enviarC()
        //{
        //    try
        //    {
        //        string TexGuarda = string.Empty;
        //        TexGuarda = "Se Edito el Docu Nro " + lblidnota.Text + " Monto S/ " + lbltotalpagar.Text;
        //        string mensaje = String.Format("{0}{1}|{2}|{3}", "* ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexGuarda);
        //        byte[] buffer = Encoding.Default.GetBytes(mensaje);
        //        ArraySegment<byte> data = new ArraySegment<byte>(buffer);
        //        await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
        //    }
        //    catch (Exception ex) { ex.ToString(); MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        //}
        public void editarPrecioA()
        {
            if (gvlista.Rows.Count >= 1)
            {
                string xid, xidpro, xum = string.Empty;
                decimal xvalor = 0;
                xid = Convert.ToString(gvlista.CurrentRow.Cells[0].Value);
                xidpro = Convert.ToString(gvlista.CurrentRow.Cells[2].Value);
                xum = Convert.ToString(gvlista.CurrentRow.Cells[5].Value);
                if (btnguardar.Enabled == true)
                {
                    xvalor = Convert.ToDecimal(gvlista.CurrentRow.Cells[11].Value);
                    if (objtemporal.editarCostoB(xid, xidpro, "A", "T", xum, xvalor))
                        listarDetalle();
                    else
                        men.EditoError();
                }
                else
                {
                    if (btneditar.Enabled == true)
                    {
                        xvalor = Convert.ToDecimal(gvlista.CurrentRow.Cells[13].Value);
                        if (objtemporal.editarCostoB(xid, xidpro, "A", "D", xum, xvalor))
                            listarB();
                        else
                            men.EditoError();
                    }
                    else
                    {
                        men.activeCajas();
                    }
                }
                gvlista.Focus();
            }
        }
        //todo
        public bool editarTodoB()
        {
            bool Escorrecto = false;
            if (gvlista.Rows.Count >= 1)
            {
                string xid, xidpro, xum = string.Empty;
                decimal xvalor = 0;
                if (btnguardar.Enabled == true)
                {
                    foreach (DataGridViewRow row in gvlista.Rows)
                    {
                        xid = Convert.ToString(row.Cells[0].Value);
                        xidpro = Convert.ToString(row.Cells[2].Value);
                        xum = Convert.ToString(row.Cells[5].Value);
                        xvalor = Convert.ToDecimal(row.Cells[11].Value);
                        Escorrecto = objtemporal.editarCostoB(xid, xidpro, "B", "T", xum, xvalor);
                        if (!Escorrecto)break;
                    }
                    if (Escorrecto) listarDetalle();
                    else men.EditoError();
                }
                else
                {
                    if (btneditar.Enabled == true)
                    {
                        foreach (DataGridViewRow row in gvlista.Rows)
                        {
                            xid = Convert.ToString(row.Cells[0].Value);
                            xidpro = Convert.ToString(row.Cells[2].Value);
                            xum = Convert.ToString(row.Cells[5].Value);
                            xvalor = Convert.ToDecimal(row.Cells[13].Value);
                            Escorrecto = objtemporal.editarCostoB(xid, xidpro, "B", "D", xum, xvalor);
                            if (!Escorrecto)break;
                        }
                        if (Escorrecto) listarB();
                        else men.EditoError();
                    }
                    else
                    {
                        men.activeCajas();
                    }
                }
                gvlista.Focus();
            }
            return Escorrecto;
        }
        public bool editarTodoA()
        {
            bool Escorrecto = false;
            if (gvlista.Rows.Count >= 1)
            {
                string xid, xidpro, xum = string.Empty;
                decimal xvalor = 0;
                if (btnguardar.Enabled == true)
                {
                    foreach (DataGridViewRow row in gvlista.Rows)
                    {
                        xid = Convert.ToString(row.Cells[0].Value);
                        xidpro = Convert.ToString(row.Cells[2].Value);
                        xum = Convert.ToString(row.Cells[5].Value);
                        xvalor = Convert.ToDecimal(row.Cells[11].Value);
                        Escorrecto = objtemporal.editarCostoB(xid, xidpro, "A", "T", xum, xvalor);
                        if (!Escorrecto) break;
                    }
                    if (Escorrecto) listarDetalle();
                    else men.EditoError();
                }
                else
                {
                    if (btneditar.Enabled == true)
                    {
                        foreach (DataGridViewRow row in gvlista.Rows)
                        {
                            xid = Convert.ToString(row.Cells[0].Value);
                            xidpro = Convert.ToString(row.Cells[2].Value);
                            xum = Convert.ToString(row.Cells[5].Value);
                            xvalor = Convert.ToDecimal(row.Cells[13].Value);
                            Escorrecto = objtemporal.editarCostoB(xid, xidpro, "A", "D", xum, xvalor);
                            if (!Escorrecto) break;
                        }
                        if (Escorrecto) listarB();
                        else men.EditoError();
                    }
                    else
                    {
                        men.activeCajas();
                    }
                }
                gvlista.Focus();
            }
            return Escorrecto;
        }
        private void cmdconcepto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cmdconcepto.Text == "MERCADERIA")
            {
                cmdcondicion.Enabled = true;
                cmdentrega.Enabled = true;
            }
            else
            {
                cmdcondicion.Text = "ALCONTADO";
                cmdentrega.Text = "INMEDIATA";
                cmdcondicion.Enabled = false;
                cmdentrega.Enabled = false;
                cmddocumento.Text = "BOLETA";
            }
            validarBoleta();
            cmddocumento.Focus();
        }
        public void controlPrint()
        {
            traerDatos();
            if (cmddocumento.ComboBox.SelectedValue.Equals("03") && xEnvioBoleta == "0")
            {
                men.permisoBoleta();
            }
            else
            {
                if (lblserie.Text.Length == 0)
                {
                    MessageBox.Show("No se le asigno una serie Predeterminada Comunicarse con Administracion", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    if (cmdconcepto.ComboBox.SelectedValue.Equals("3"))//Contingencia
                    {
                        MessageBox.Show("Si Selecciono un Documento de CONTINGENCIA solo puede Guardar(Ctrl + G)", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        xAvisoPrint = 0;
                        txtcodigo.Text = "";
                        txtcodigo.Focus();
                    }
                    else
                    {
                        if (cmddocumento.ComboBox.SelectedValue.Equals("03"))
                        {
                            xAvisoPrint = 1;
                            validaImprimeA();
                            xAvisoPrint = 0;
                        }
                        else if (cmddocumento.ComboBox.SelectedValue.Equals("01"))
                        {
                            MessageBox.Show("Si selecciono una Factura... Guarde y envie a SUNAT primero para poder imprimir", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            xAvisoPrint = 0;
                            txtcodigo.Text = "";
                            txtcodigo.Focus();
                        }
                        else
                        {
                            xAvisoPrint = 2;
                            validaImprimeA();
                            xAvisoPrint = 0;
                        }
                    }
                }
            }
        }
        private void btnimprimir_Click(object sender, EventArgs e)
        {
            controlPrint();
        }
        private void btneditar_Click(object sender, EventArgs e)
        {
            editaServicio();
        }
        private void btnguardar_Click(object sender, EventArgs e)
        {
            xAvisoPrint = 0;
            validaServicio();
        }
        private void btnlimpiar_Click(object sender, EventArgs e)
        {
            limpiar();
        }
        private void btneliminar_Click(object sender, EventArgs e)
        {
            botonEliminar();
        }
        private void btnactivar_Click(object sender, EventArgs e)
        {
            botonActivar();
        }
        private void txtnrodoc_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)32) e.Handled = true;
            Validar.SoloNumeros(e);
        }
        private void cmddocumento_SelectedIndexChanged(object sender, EventArgs e)
        {
            validarBoleta();
            if (txtnrodoc.Enabled == true)
            {
                txtnrodoc.SelectionStart = txtnrodoc.Text.Length;
                txtnrodoc.Focus();
            }
            else
            {
                txtcliente.SelectionStart = txtcliente.Text.Length;
                txtcliente.Focus();
            }
        }
        FrmGanancia frm;
        private void linkdetalle_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (btnguardar.Enabled == true)
            {
                men.SeleccioneDocumento();
            }
            else
            {
                frm = new FrmGanancia();
                frm.xNotaId = this.lblidnota.Text;
                frm.xEstado = this.lblestado.Text;
                frm.Show();
            }
        }
        private void FrmNotaPedido_Shown(object sender, EventArgs e)
        {
            objetopro = new List<EListaProducto>();
        }
        private void gvpanel_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (gvpanel.Rows.Count > 0)
                {
                    if (gvpanel.CurrentCell.ColumnIndex == 2)
                    {
                        if (Convert.ToString(gvpanel.CurrentRow.Cells[4].Value) == "FACTURA")
                        {
                            xdocu = new FrmDocumento();
                            xdocu.xid = Convert.ToString(gvpanel.CurrentRow.Cells[3].Value);
                            xdocu.xdocumento = Convert.ToString(gvpanel.CurrentRow.Cells[4].Value);
                            xdocu.xcliente = Convert.ToString(gvpanel.CurrentRow.Cells[7].Value);
                            xdocu.xcondicion = Convert.ToString(gvpanel.CurrentRow.Cells[10].Value);
                            xdocu.xFormaPago = Convert.ToString(gvpanel.CurrentRow.Cells[11].Value);
                            xdocu.xmovilidad = Convert.ToString(gvpanel.CurrentRow.Cells[18].Value);
                            xdocu.xdescuento = Convert.ToString(gvpanel.CurrentRow.Cells[19].Value);
                            xdocu.xadicional = Convert.ToString(gvpanel.CurrentRow.Cells[21].Value);
                            xdocu.xPersonal = Convert.ToString(gvpanel.CurrentRow.Cells[23].Value);
                            xdocu.xEstado = Convert.ToString(gvpanel.CurrentRow.Cells[24].Value);
                            xdocu.xCompania = Convert.ToString(gvpanel.CurrentRow.Cells[25].Value);
                            xdocu.xEfectivo = Convert.ToString(gvpanel.CurrentRow.Cells[34].Value);
                            xdocu.xVuelto = Convert.ToString(gvpanel.CurrentRow.Cells[35].Value);
                            xdocu.xIdUsuario = xidUsuario;
                            xdocu.xIGV = xIGV;
                            xdocu.ShowDialog();
                            int pos = bs.Position;
                            if (txtbuscar.Text.Length == 0)
                            {
                                listar();
                                if (gvpanel.Rows.Count > 0) gvpanel.CurrentCell = gvpanel.CurrentRow.Cells[2];
                                bs.Position = pos;
                            }
                            else
                            {
                                listar();
                                buscarTexto();
                                if (gvpanel.Rows.Count > 0) gvpanel.CurrentCell = gvpanel.CurrentRow.Cells[2];
                                bs.Position = pos;
                            }
                        }
                        else
                        {
                            MessageBox.Show("Seleccione solo Factura para imprimir,enviar a SUNAT", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                    }
                    else if (gvpanel.CurrentCell.ColumnIndex == 0)
                    {
                        solicitarDatos();
                    }
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
            }
        }
        private void txtefectivo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                if (txtefectivo.Text.Length > 7)
                {
                    MessageBox.Show("Intento ingresar el codigo de un producto en el campo efectivo..favor de verificarlo", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtefectivo.Text = "";
                    txtcodigo.Text = "";
                    txtcodigo.Focus();
                }
                else
                {
                    if (cmddocumento.ComboBox.SelectedValue.ToString() != "01")
                    {
                        controlPrint();
                    }
                    else
                    {
                        if (btnguardar.Enabled == true)
                        {
                            xAvisoPrint = 0;
                            validaServicio();
                        }
                        else
                        {
                            if (btneditar.Enabled == true) editaServicio();
                            else men.activeCajas();
                        }
                    }
                }
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtefectivo.Text.Length; i++)
            {
                if (txtefectivo.Text[i] == '.')
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
        private void txtefectivo_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey) txtdescuento.Focus();
        }
        private void txtefectivo_TextChanged(object sender, EventArgs e)
        {
            descuentos();
        }
        private void txtmovilidad_TextChanged(object sender, EventArgs e)
        {
            descuentos();
        }
        private void txtdescuento_TextChanged(object sender, EventArgs e)
        {
            if (txtdescuento.Text.Length == 0)
            {
                descuentos();
            }
            else
            {
                if (btnactivar.Enabled == false)
                {
                    if (double.Parse(lbltotalpagar.Text) <= 0)
                    {
                        MessageBox.Show("NO PUEDES APLICAR EL DESCUENTO CUANDO EL TOTAL DEL DOCUMENTO ES MENOR O IGUAL A CERO...!!!", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                        txtdescuento.Text = "";
                        txtdescuento.Focus();
                    }
                    else
                    {
                        if (double.Parse(txtdescuento.Text) > xDescuentoMax)
                        {
                            MessageBox.Show("EL DESCUENTO MAXIMO QUE PUEDES REALIZAR ES DE S/ " + xDescuentoMax.ToString("N2") + " !!", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                            txtdescuento.Text = "";
                            txtdescuento.Focus();
                        }
                        else
                        {
                            descuentos();
                        }
                    }
                }
            }
        }
        private void cmdMesas_SelectionChangeCommitted(object sender, EventArgs e)
        {
            listarDetalleMesa();
        }
        private void cmdMesas_MouseEnter(object sender, EventArgs e)
        {
            if (cmdMesas.Items.Count <= 0) cmdMesas.Enabled = false;
            else cmdMesas.Enabled = true;
        }
        private void cmdMesas_MouseMove(object sender, MouseEventArgs e)
        {
            if (cmdMesas.Items.Count <= 0) cmdMesas.Enabled = false;
            else cmdMesas.Enabled = true;
        }
        private void chkLlevar_CheckedChanged(object sender, EventArgs e)
        {
            if (chkLlevar.Checked == true)
            {
                cmdMesas.Visible = false;
                lbltextoB.Visible = false;
                chkbuscar.Checked =true;
                chkbuscar.Enabled = true;
                txtcodigo.Enabled = true;
                cmdsublinea.Visible = true;
                lbltextoA.Visible = true;
                buscarSublinea();
                txtcodigo.Text = "";
                txtcodigo.Focus();
            }
            else
            {
                cmdMesas.Visible =true;
                lbltextoB.Visible = true;
                chkbuscar.Checked = false;
                chkbuscar.Enabled =false;
                txtcodigo.Enabled =false;
                cmdsublinea.Visible =false;
                lbltextoA.Visible =false;
                txtcodigo.Text = "";
            }
        }
        private void cmdsublinea_SelectionChangeCommitted(object sender, EventArgs e)
        {
            buscarSublinea();
        }
        private void cmdforma_SelectionChangeCommitted(object sender, EventArgs e)
        {
            botonforma();
        }
        private void cmdcondicion_SelectionChangeCommitted(object sender, EventArgs e)
        {
            botoncondicion();
        }
        private void cmdfiltrar_SelectionChangeCommitted(object sender, EventArgs e)
        {
            filtrar();
            txtbuscar.Focus();
        }
        private void gvproducto_ColumnAdded(object sender, DataGridViewColumnEventArgs e)
        {
            gvproducto.Columns[e.Column.Index].SortMode = DataGridViewColumnSortMode.NotSortable;
        }
        private void gvlista_ColumnAdded(object sender, DataGridViewColumnEventArgs e)
        {
            gvlista.Columns[e.Column.Index].SortMode = DataGridViewColumnSortMode.NotSortable;
        }
        private void dtimeinicio_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)txtbuscar.Focus();
        }
        #region exportarBoletas
        private void exportarBoleta()
        {
            TEXTO.Document doc = new TEXTO.Document(TEXTO.PageSize.A4, 10, 10, 10, 10);
            filename = string.Empty;
            string xarchivo = string.Empty;
            xarchivo = String.Format("{0}-{1}-{2}-{3}.PDF", xRuc, "03", lblserie.Text, txtnrodoc.Text);
            filename = "\\\\" + conexion.ServidorIP + "\\ArchivoSistema\\CPE\\PRODUCCION\\" + xarchivo;
            if (filename.Trim() != "")
            {
                FileStream file = new FileStream(filename,
                               FileMode.OpenOrCreate,
                               FileAccess.ReadWrite,
                               FileShare.ReadWrite);
                PDFX.PdfWriter writer = PDFX.PdfWriter.GetInstance(doc, file);
                doc.Open();
                string xnrodocu, xfecha, xcliente, xfiscal, xruta, xforma, xdni,
                    xmoneda = string.Empty;
                string xdierccion = string.Empty;
                xnrodocu = lblserie.Text + "-" + txtnrodoc.Text;
                xfecha = " Fecha de Emision:           " + detimepago.Text;
                xforma = " Forma Pago:                    AL CONTADO";
                xcliente = " Señor(es):                        " + txtcliente.Text;
                xfiscal = " Direccion:                         " + txtfiscal.Text;
                xdni = " D.N.I:                                " + txtdni.Text;
                xmoneda = " Moneda:                           SOLES";
                xruta = @"D:\mp3\BOLETA_SAPECHI.png";
                TEXTO.Image imagen = TEXTO.Image.GetInstance(xruta);
                imagen.BorderWidth = 0;
                imagen.SetAbsolutePosition(415f, 755f);
                imagen.ScalePercent(22);
                doc.Add(imagen);
                TEXTO.Chunk chunk = new TEXTO.Chunk(" "+conexion.NombreComercialPDF, TEXTO.FontFactory.GetFont("Calibri", 14, TEXTO.Font.BOLD));
                doc.Add(new TEXTO.Paragraph(chunk));
                doc.Add(new TEXTO.Paragraph("  ", TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(" "+conexion.DireccionPDF, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph("                                                                                                                                      " + xnrodocu, TEXTO.FontFactory.GetFont("Calibri", 12, TEXTO.Font.BOLD)));
                doc.Add(new TEXTO.Paragraph(xfecha, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(xforma, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(xcliente, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(xfiscal, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(xdni, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph(xmoneda, TEXTO.FontFactory.GetFont("Calibri", 9)));
                doc.Add(new TEXTO.Paragraph("                       "));
                GenerarDocumentoB(doc);
                doc.Add(new TEXTO.Paragraph("                       "));
                TEXTO.Image imgB = TEXTO.Image.GetInstance(codigoQR().ToString());
                imgB.BorderWidth = 0;
                int nropaginas = writer.PageNumber;
                if (tableHeight > 0 && tableHeight <= 476)
                {
                    generaTotalPDF_B(doc, writer);
                    imgB.SetAbsolutePosition(290, 540 - tableHeight);//480//265
                }
                else if (tableHeight >= 476 && tableHeight <= 600)
                {
                    doc.NewPage();
                    generaTotalPDF_B(doc, writer);
                    imgB.SetAbsolutePosition(290, 750);//690
                }
                else
                {
                    generaTotalPDF_B(doc, writer);
                    if (tableHeight == 627) imgB.SetAbsolutePosition(290, 730);//670
                    else imgB.SetAbsolutePosition(290, 710 - (tableHeight - 627));//650
                }
                imgB.ScalePercent(30, 30);
                doc.Add(imgB);
                doc.Close();
            }
        }
        public string codigoQR()
        {
            string xvalorBarra, xruta = string.Empty;
            string xarchivo = string.Empty;
            DateTime vfecha;
            vfecha = Convert.ToDateTime(detimepago.Text);
            xarchivo = String.Format("{0}-{1}-{2}-{3}.PNG", xRuc, "03", lblserie.Text, txtnrodoc.Text);
            xvalorBarra = xRuc + "|03|" + lblserie.Text + "|" + txtnrodoc.Text + "|" + lbligv.Text + "|" + lbltotalpagar.Text + "|" + vfecha.ToString("yyyy-MM-dd") + "|01|" + txtdni.Text;
            xruta = "\\\\" + conexion.ServidorIP + "\\ArchivoSistema\\CPE\\CODIGOBARRA\\" + xarchivo;
            Image pbgenerar = null;
            BarcodeWriter br = new BarcodeWriter();
            br.Format = BarcodeFormat.QR_CODE;
            Bitmap bm = new Bitmap(br.Write(xvalorBarra), 300, 300);
            pbgenerar = bm;
            pbgenerar.Save(xruta);
            return xruta;
        }
        public static float CalculatePdfPTableHeight(PDFX.PdfPTable table)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (TEXTO.Document doc = new TEXTO.Document(TEXTO.PageSize.TABLOID))
                {
                    using (PDFX.PdfWriter w = PDFX.PdfWriter.GetInstance(doc, ms))
                    {
                        doc.Open();
                        table.WriteSelectedRows(0, table.Rows.Count, 0, 0, w.DirectContent);
                        doc.Close();
                        return table.TotalHeight;
                    }
                }
            }
        }
        public void GenerarDocumentoB(TEXTO.Document document)
        {
            int i;
            PDFX.PdfPTable datatable = new PDFX.PdfPTable(6);
            datatable.DefaultCell.Padding = 3;
            float[] headerwidths = new float[6] { 7, 13, 11, 55, 13, 13 };//9
            datatable.SetWidths(headerwidths);
            datatable.WidthPercentage = 100;
            datatable.DefaultCell.BorderWidth = 1;
            datatable.DefaultCell.HorizontalAlignment = 1;
            datatable.AddCell(new TEXTO.Phrase("N°", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.AddCell(new TEXTO.Phrase("CANTIDAD", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.AddCell(new TEXTO.Phrase("UNIDAD", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.AddCell(new TEXTO.Phrase("DESCRIPCION", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.AddCell(new TEXTO.Phrase("P.UNIT.", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.AddCell(new TEXTO.Phrase("IMPORTE", TEXTO.FontFactory.GetFont("Calibri", 9)));
            datatable.HeaderRows = 1;
            PDFX.PdfPCell items = null;
            PDFX.PdfPCell cellCant = null;
            PDFX.PdfPCell cellUNI = null;
            PDFX.PdfPCell cellDes = null;
            PDFX.PdfPCell cellPre = null;
            PDFX.PdfPCell cellImp = null;
            int xcount = gvlista.Rows.Count;
            int xitem = 0;
            for (i = 0; i < xcount; i++)
            {
                xitem = i + 1;
                items = new PDFX.PdfPCell(new TEXTO.Phrase(xitem.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                items.HorizontalAlignment = 2;
                items.UseAscender = false;
                datatable.AddCell(items);
                cellCant = new PDFX.PdfPCell(new TEXTO.Phrase(gvlista[4, i].Value.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellCant.HorizontalAlignment = 2;
                cellCant.UseAscender = false;
                datatable.AddCell(cellCant);
                cellUNI = new PDFX.PdfPCell(new TEXTO.Phrase(gvlista[5, i].Value.ToString().Substring(0, 3), TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellUNI.HorizontalAlignment = 0;
                cellUNI.UseAscender = false;
                datatable.AddCell(cellUNI);
                cellDes = new PDFX.PdfPCell(new TEXTO.Phrase(gvlista[6, i].Value.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellDes.HorizontalAlignment = 0;
                cellDes.UseAscender = false;
                datatable.AddCell(cellDes);
                cellPre = new PDFX.PdfPCell(new TEXTO.Phrase(gvlista[8, i].Value.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellPre.HorizontalAlignment = 2;
                cellPre.UseAscender = false;
                datatable.AddCell(cellPre);
                cellImp = new PDFX.PdfPCell(new TEXTO.Phrase(gvlista[9, i].Value.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellImp.HorizontalAlignment = 2;
                cellImp.UseAscender = false;
                datatable.AddCell(cellImp);
                datatable.CompleteRow();
            }
            if (decimal.Parse(lblmtc.Text) > 0)
            {
                xitem = i + 1;
                items = new PDFX.PdfPCell(new TEXTO.Phrase(xitem.ToString(), TEXTO.FontFactory.GetFont("Calibri", 8)));
                items.HorizontalAlignment = 2;
                items.UseAscender = false;
                datatable.AddCell(items);
                cellCant = new PDFX.PdfPCell(new TEXTO.Phrase("1.00", TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellCant.HorizontalAlignment = 2;
                cellCant.UseAscender = false;
                datatable.AddCell(cellCant);
                cellUNI = new PDFX.PdfPCell(new TEXTO.Phrase("UNI", TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellUNI.HorizontalAlignment = 0;
                cellUNI.UseAscender = false;
                datatable.AddCell(cellUNI);
                cellDes = new PDFX.PdfPCell(new TEXTO.Phrase("MV/CT/DS", TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellDes.HorizontalAlignment = 0;
                cellDes.UseAscender = false;
                datatable.AddCell(cellDes);
                cellPre = new PDFX.PdfPCell(new TEXTO.Phrase(lblmtc.Text, TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellPre.HorizontalAlignment = 2;
                cellPre.UseAscender = false;
                datatable.AddCell(cellPre);
                cellImp = new PDFX.PdfPCell(new TEXTO.Phrase(lblmtc.Text, TEXTO.FontFactory.GetFont("Calibri", 8)));
                cellImp.HorizontalAlignment = 2;
                cellImp.UseAscender = false;
                datatable.AddCell(cellImp);
                datatable.CompleteRow();
            }
            document.Add(datatable);
            tableHeight = CalculatePdfPTableHeight(datatable);
        }
        public void generaTotalPDF_B(TEXTO.Document document, PDFX.PdfWriter writer)
        {
            PDFX.PdfPTable tableB = new PDFX.PdfPTable(3);
            PDFX.PdfPCell cell = new PDFX.PdfPCell(new TEXTO.Phrase("SON: " + txtletras.Text, TEXTO.FontFactory.GetFont("Calibri", 8)));
            cell.Border = 0;
            cell.Colspan = 3;
            cell.HorizontalAlignment = 0;//0=Left, 1=Centre, 2=Right
            PDFX.PdfPCell cellA = new PDFX.PdfPCell(new TEXTO.Phrase("________________________________________________________________________________________________________________________________°", TEXTO.FontFactory.GetFont("Calibri", 8)));
            cellA.Border = 0;
            cellA.Colspan = 3;
            cellA.HorizontalAlignment = 0;//0=Left, 1=Centre, 2=Right
            float[] headerwidths = new float[3] { 110, 50, 30 };
            tableB.SetWidths(headerwidths);
            tableB.WidthPercentage = 100;
            tableB.DefaultCell.HorizontalAlignment = 2;
            PDFX.PdfPCell cellAuto, cellGrabada, cellsubtotal, repre, cellinafecta, cellIna,
            hash, cellDescuento, cellDesB, t1, t2, t3, cellIgv, cellIGVB,
            cellisc, celliscB, celltotal, celltotalB = null;
            cellAuto = new PDFX.PdfPCell(new TEXTO.Phrase("Autorizado mediante la resolucion de intendencia", TEXTO.FontFactory.GetFont("Calibri", 8)));
            cellAuto.HorizontalAlignment = 0;
            cellAuto.Border = 0;
            cellGrabada = new PDFX.PdfPCell(new TEXTO.Phrase("OP.GRAVADAS S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellGrabada.HorizontalAlignment = 2;
            cellGrabada.Border = 0;
            cellsubtotal = new PDFX.PdfPCell(new TEXTO.Phrase(xSUB_FIJO, TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellsubtotal.HorizontalAlignment = 2;
            cellsubtotal.Border = 0;
            repre = new PDFX.PdfPCell(new TEXTO.Phrase("SUNAT/N° 032-005", TEXTO.FontFactory.GetFont("Calibri", 8)));
            repre.HorizontalAlignment = 0;
            repre.Border = 0;
            cellinafecta = new PDFX.PdfPCell(new TEXTO.Phrase("DESCUENTOS S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellinafecta.HorizontalAlignment = 2;
            cellinafecta.Border = 0;
            cellIna = new PDFX.PdfPCell(new TEXTO.Phrase(xDES_FIJO, TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellIna.HorizontalAlignment = 2;
            cellIna.Border = 0;
            cellIna.UseAscender = false;
            hash = new PDFX.PdfPCell(new TEXTO.Phrase("Representacion impresa de la factura electronica", TEXTO.FontFactory.GetFont("Calibri", 8)));
            hash.HorizontalAlignment = 0;
            hash.Border = 0;
            cellDescuento = new PDFX.PdfPCell(new TEXTO.Phrase("SUB TOTAL S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellDescuento.HorizontalAlignment = 2;
            cellDescuento.Border = 0;
            cellDesB = new PDFX.PdfPCell(new TEXTO.Phrase(lblsubsunat.Text, TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellDesB.HorizontalAlignment = 2;
            cellDesB.Border = 0;
            t1 = new PDFX.PdfPCell(new TEXTO.Phrase("Consulta tu Comprobante en: -http://e-consulta.sunat.gob.pe", TEXTO.FontFactory.GetFont("Calibri", 8)));
            t1.HorizontalAlignment = 0;
            t1.Border = 0;
            cellIgv = new PDFX.PdfPCell(new TEXTO.Phrase("I.G.V(18.00)% S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellIgv.HorizontalAlignment = 2;
            cellIgv.Border = 0;
            cellIGVB = new PDFX.PdfPCell(new TEXTO.Phrase(lbligv.Text, TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellIGVB.HorizontalAlignment = 2;
            cellIGVB.Border = 0;
            t2 = new PDFX.PdfPCell(new TEXTO.Phrase("Email: " + conexion.CorreoEMP, TEXTO.FontFactory.GetFont("Calibri", 8)));
            t2.HorizontalAlignment = 0;
            t2.Border = 0;
            cellisc = new PDFX.PdfPCell(new TEXTO.Phrase("ICBPER S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            cellisc.HorizontalAlignment = 2;
            cellisc.Border = 0;
            celliscB = new PDFX.PdfPCell(new TEXTO.Phrase("0.00", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            celliscB.HorizontalAlignment = 2;
            celliscB.Border = 0;
            t3 = new PDFX.PdfPCell(new TEXTO.Phrase("Nro Id: " + lblidnota.Text, TEXTO.FontFactory.GetFont("Calibri", 8)));
            t3.HorizontalAlignment = 0;
            t3.Border = 0;
            celltotal = new PDFX.PdfPCell(new TEXTO.Phrase("TOTAL S/", TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            celltotal.HorizontalAlignment = 2;
            celltotal.Border = 0;
            celltotalB = new PDFX.PdfPCell(new TEXTO.Phrase(lbltotalpagar.Text, TEXTO.FontFactory.GetFont("Calibri", 10, TEXTO.Font.BOLD)));
            celltotalB.HorizontalAlignment = 2;
            celltotalB.Border = 0;
            tableB.AddCell(cell);
            tableB.AddCell(cellA);
            tableB.AddCell(cellAuto);
            tableB.AddCell(cellGrabada);
            tableB.AddCell(cellsubtotal);
            tableB.AddCell(repre);
            tableB.AddCell(cellinafecta);
            tableB.AddCell(cellIna);
            tableB.AddCell(hash);
            tableB.AddCell(cellDescuento);
            tableB.AddCell(cellDesB);
            tableB.AddCell(t1);
            tableB.AddCell(cellIgv);
            tableB.AddCell(cellIGVB);
            tableB.AddCell(t2);
            tableB.AddCell(cellisc);
            tableB.AddCell(celliscB);
            tableB.AddCell(t3);
            tableB.AddCell(celltotal);
            tableB.AddCell(celltotalB);
            document.Add(tableB);
        }
        #endregion

        private void cmdMesas_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
