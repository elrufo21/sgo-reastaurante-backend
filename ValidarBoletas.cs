using System;
using System.Data;
using System.Windows.Forms;
using MegaRosita.Capa.Comun;
using RestSharp;
namespace MegaRosita.Capa.Aplicacion
{
    public partial class ValidarBoletas : Form
    {
        String _Token = String.Empty;
        Conexion xconexion = new Conexion();
        public string xRuc {get; set;}
        public string xIdCompy { get; set;}
        public string xIdRe { get; set;}
        public string xDocumento { get; set;}
        public string xFechaEmision { get; set;}
        public int xAviso = 0;
        public string xEstado { get; set;}
        public string xClientSecret { get; set;}
        public string xApiToken {get; set;}
        
        Mensajes men = new Mensajes();
        
        public ValidarBoletas()
        {
            InitializeComponent();
        }
        #region ConsultaValidez
        public void generarToken()
        {
            var client = new RestClient("https://api-seguridad.sunat.gob.pe/v1/clientesextranet/"+xClientSecret+"/oauth2/token/");
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/x-www-form-urlencoded");
            request.AddParameter("grant_type", "client_credentials");
            request.AddParameter("scope", "https://api.sunat.gob.pe/v1/contribuyente/contribuyentes");
            request.AddParameter("client_id",xClientSecret);
            request.AddParameter("client_secret",xApiToken);//
            request.AddParameter("expires_in", "432000");
            //request.AddParameter("expires_at", "2050-12-30");
            IRestResponse response = client.Execute(request);
            String _Contenido = String.Empty;
            String[] _Valores;
            String xdata = String.Empty;
            _Token = String.Empty;
            xdata = response.Content;
            _Contenido = xdata.Replace("{", "").Replace('"', ' ').Trim().Replace("access_token : ", "").Replace("}", "");
            _Valores = _Contenido.Split(',');
            _Token = _Valores[0].Trim();
        }
        public void consultarBoleta()
        {
            if (_Token.Contains("error_description : cliente no autorizado"))
            {
                MessageBox.Show("ERROR" + _Token, "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
            {
                if (txtserie.Text.Length < 4)
                {
                    MessageBox.Show("Ingrese correctamente la serie", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtserie.Focus();
                }
                else if (txtnumero.Text.Length == 0)
                {
                    MessageBox.Show("Ingrese el Numero de documento", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtnumero.Focus();
                }
                else if (txtmonto.Text.Length == 0)
                {
                    MessageBox.Show("Ingrese el monto total del documento", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtnumero.Focus();
                }
                else
                {
                    string xnumero = string.Empty;
                    string xfecha = string.Empty;
                    double xmonto = 0;
                    xnumero = txtnumero.Text;
                    xfecha = dtimefecha.Value.ToString("dd/MM/yyyy");
                    xmonto = double.Parse(txtmonto.Text);
                    string xdatos = string.Empty;
                    var client = new RestClient("https://api.sunat.gob.pe/v1/contribuyente/contribuyentes/" + xRuc + "/validarcomprobante");
                    client.Timeout = -1;
                    var request = new RestRequest(Method.POST);
                    request.AddHeader("Content-Type", "application/json");
                    request.AddHeader("Authorization", "Bearer " + _Token);
                    request.AddParameter("application/json", "{\r\n\"numRuc\":\"" + xRuc + "\",\r\n\"codComp\":\"" + cmddocumento.SelectedValue.ToString() + "\",\r\n\"numeroSerie\":\"" + txtserie.Text + "\",\r\n\"numero\":\"" + xnumero + "\",\r\n\"fechaEmision\":\"" + xfecha + "\",\r\n\"monto\":\"" + xmonto.ToString() + "\"\r\n}", ParameterType.RequestBody);
                    IRestResponse response = client.Execute(request);
                    string xdata = response.Content;
                    xdatos = xdata.Replace("{", "").Replace('"', ' ').Trim().Replace("success :true,", "").Trim().Replace("message : Operation Success!  ,", "").Replace(" data : ", "").Replace("}", "");
                    if (xdatos.Length > 0)
                    {
                        string[] xInfo;
                        string[] xCBC;
                        xInfo = xdatos.Split(',');
                        xCBC = xInfo[0].Split(':');
                        //lblmensaje.Text = xCBC[0].ToUpper();
                        lblcodigo.Text = xCBC[1];
                        if (lblcodigo.Text == "401")
                        {
                            generarToken();
                            consultarBoleta();
                        }
                        else
                        {
                            if (lblcodigo.Text.Length == 0 || lblcodigo.Text == "")
                            {
                                MessageBox.Show("Error: Datos del Emisor incorrectos", "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                            else
                            {
                                string xAviso = string.Empty;
                                int xvalor = int.Parse(lblcodigo.Text);
                                switch (xvalor)
                                {
                                    case 0:
                                        xAviso = "NO EXISTE (Comprobante no informado)";
                                        lblcodigo.ForeColor = System.Drawing.Color.Red;
                                        lblmensaje.ForeColor = System.Drawing.Color.Red;
                                        break;
                                    case 1:
                                        xAviso = "ACEPTADO (Comprobante aceptado)";
                                        lblcodigo.ForeColor = System.Drawing.Color.Black;
                                        lblmensaje.ForeColor = System.Drawing.Color.Black;
                                        break;
                                    case 2:
                                        xAviso = "ANULADO (Comunicado en una baja)";
                                        break;
                                    case 3:
                                        xAviso = "AUTORIZADO (con autorización de imprenta)";
                                        break;
                                    case 4:
                                        xAviso = "NO AUTORIZADO (no autorizado por imprenta)";
                                        break;
                                    default:
                                        xAviso = "SUNAT Colapso intente en unos segundos...";
                                        lblcodigo.ForeColor = System.Drawing.Color.Black;
                                        lblmensaje.ForeColor = System.Drawing.Color.Black;
                                        break;
                                }
                                lblmensaje.Text = xAviso;
                                if (xvalor == 1||xvalor==2)
                                {
                                    MessageBox.Show(xAviso, "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Information);
                                }
                                else
                                {
                                    MessageBox.Show(xAviso, "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                                }
                                editarResumen(xvalor);
                            }
                        }
                    }
                }
            }
        }
        public void editarResumen(int xValor)
        {
            if (xValor== 1|| xValor ==2)
            {
                AccesoDatos daSQL = new AccesoDatos("con");
                string rpt = daSQL.ejecutarConsulta("update ResumenBoletas set CodigoSunat = '" + lblcodigo.Text + "', MensajeSunat = '" + lblmensaje.Text + "' " +
                "where ResumenId = '" + xIdRe + "' select 'true'");
                if (rpt == "") men.EditoError();
            }
            else if (xValor == 0)
            {
                if (!xEstado.Equals("B"))
                {
                    AccesoDatos daSQLB = new AccesoDatos("con");
                    string rptB = daSQLB.ejecutarComando("uspRetornaBoletaPorTicket", "@ResumenId", xIdRe);
                    if (string.IsNullOrEmpty(rptB))
                    {
                        men.ErrorGuardado();
                    }
                    else
                    {
                        MessageBox.Show("EL DOCUMENTO NO SE ENVIO A SUNAT...SE RETORNARA PARA VOLVERLA A ENVIAR EN UNOS MINUTOS", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                }
            }
        }
        #endregion
        public void cargarCompania()
        {
            DataTable dt;
            dt = new DataTable("Tabla");
            dt.Columns.Add("Codigo");
            dt.Columns.Add("Descripcion");
            DataRow dr;
            dr = dt.NewRow();
            dr["Codigo"] = xconexion.xRuc.Trim();
            dr["Descripcion"] = xconexion.NombreComercialPDF.Trim();
            dt.Rows.Add(dr);
            cmdcompania.DataSource = dt;
            cmdcompania.ValueMember = "Codigo";
            cmdcompania.DisplayMember = "Descripcion";
        }
        public void cargaDocumento()
        {
            DataTable dt;
            dt = new DataTable("Tabla");
            dt.Columns.Add("Codigo");
            dt.Columns.Add("Descripcion");
            DataRow dr;
            dr = dt.NewRow();
            dr["Codigo"] = "03";
            dr["Descripcion"] = "BOLETA";
            dt.Rows.Add(dr);
            dr = dt.NewRow();
            dr["Codigo"] = "01";
            dr["Descripcion"] = "FACTURA";
            dt.Rows.Add(dr);
            cmddocumento.DataSource = dt;
            cmddocumento.ValueMember = "Codigo";
            cmddocumento.DisplayMember = "Descripcion";
        }
        public void limpiar()
        {
            cmddocumento.Text = "BOLETA";
            txtserie.Text = "B001";
            txtnumero.Text = "";
            lblmensaje.Text = "";
            lblcodigo.Text = "";
            dtimefecha.Text=DateTime.Now.ToString("dd/MM/yyyy");
            txtmonto.Text = "";
            lblcodigo.ForeColor = System.Drawing.Color.Black;
            lblmensaje.ForeColor = System.Drawing.Color.Black;
            txtserie.SelectionStart = txtserie.Text.Length;
            txtserie.Focus();
        }
        public void cargarload()
        {
            cargarCompania();
            cargaDocumento();
            lblmensaje.Text = "";
            txtserie.Text = "B001";
            lblcodigo.Text = "";
            lblcodigo.Text = "";
            lblmensaje.Text = "";
            if (xAviso == 1)
            {
                cmdcompania.SelectedValue= xRuc;
                dtimefecha.Text = xFechaEmision;
                cmddocumento.Text = xDocumento;
                cmdcompania.Enabled = false;
                cmddocumento.Enabled = false;
                dtimefecha.Enabled = false;
                txtserie.Enabled = false;
                txtnumero.Enabled = false;
                txtmonto.Enabled = false;
                btnnuevo.Visible = false;
                traerDocumento();
            }
        }
        public void traerDocumento()
        {
            string xEstadoDocu = string.Empty;
            if (xEstado == "E") xEstadoDocu = "EMITIDO";
            else xEstadoDocu = "BAJA";
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarConsulta("select isnull((select STUFF((select top 1 '¬' + d.DocuSerie + '|' + d.DocuNumero + '|' +"+
            "convert(varchar, d.DocuTotal) from DocumentoVenta d where CompaniaId ='"+xIdCompy+"' and DocuEmision ='"+xFechaEmision+"' and " +
            "TipoCodigo = '"+cmddocumento.SelectedValue.ToString()+ "' and d.DocuEstado='"+xEstadoDocu+"'" +
            "FOR XML path('')), 1, 1, '')),'~')");
            if (rpt != "")
            {
                if(!rpt.Contains("~"))
                {
                    string[] vdata;
                    vdata = rpt.Split('|');
                    txtnumero.Text = vdata[0].ToString();
                    txtnumero.Text = vdata[1].ToString();
                    txtmonto.Text = vdata[2].ToString();
                }
            }
        }
        private void ValidarBoletas_Load(object sender, EventArgs e)
        {
            cargarload();
        }
        private void txtnumero_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                dtimefecha.Focus();
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtnumero.Text.Length; i++)
            {
                if (txtnumero.Text[i] == '.')
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
        private void txtmonto_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                consultarBoleta();
            }
            if (e.KeyChar == 8)
            {
                e.Handled = false;
                return;
            }
            bool IsDec = false;
            int nroDec = 0;
            for (int i = 0; i < txtmonto.Text.Length; i++)
            {
                if (txtmonto.Text[i] == '.')
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
        private void dtimefecha_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txtmonto.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void cmddocumento_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if(cmddocumento.Text=="FACTURA")
            {
                txtserie.Text = "F001";
                txtserie.SelectionStart = txtserie.Text.Length;
                txtserie.Focus();
            }
            else
            {
                txtserie.Text = "B001";
                txtserie.SelectionStart = txtserie.Text.Length;
                txtserie.Focus();
            }
        }
        private void txtserie_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)32)
                e.Handled = true;
            else if (e.KeyChar == (char)13)
            {
                e.Handled = true;
                txtnumero.SelectionStart = txtnumero.Text.Length;
                txtnumero.Focus();
            }
            else
            {
                e.Handled = false;
            }
        }
        private void txtserie_TextChanged(object sender, EventArgs e)
        {
            txtserie.CharacterCasing = CharacterCasing.Upper;
        }
        private void btnnuevo_Click(object sender, EventArgs e)
        {
            limpiar();
        }
        private void txtmonto_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)dtimefecha.Focus();
        }
        private void dtimefecha_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey) txtnumero.Focus();
        }
        private void txtnumero_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey)
            {
                txtserie.SelectionStart = txtserie.Text.Length;
                txtserie.Focus();
            }
        }
        private void cmdcompania_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)cmddocumento.Focus();
        }
        private void cmdcompania_SelectionChangeCommitted(object sender, EventArgs e)
        {
            cmddocumento.Focus();
        }
        private void txtserie_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey) cmddocumento.Focus();
        }
        private void cmddocumento_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.ShiftKey) cmdcompania.Focus();
            else if (e.KeyCode == Keys.Enter)
            {
                txtserie.SelectionStart = txtserie.Text.Length;
                txtserie.Focus();
            }
        }
        private void btnconsultar_Click(object sender, EventArgs e)
        {
            consultarBoleta();
        }
        private void ValidarBoletas_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }
    }
}
