using System;
using System.Collections.Generic;
using System.Data;
using System.Windows.Forms;
using MegaRosita.Capa.Comun;
using MegaRosita.Capa.Entidades;

namespace MegaRosita.Capa.Aplicacion
{
    public partial class frmCambioMesa : Form
    {
        public ControlMesas principal;
        Mensajes men = new Mensajes();
        public frmCambioMesa(ControlMesas frm)
        {
            InitializeComponent();
            this.principal = frm;
            listarMesasLibres();
            listarMesasOcupadas();
        }
        public void listarMesasOcupadas()
        {
            string[] listaMesas;
            int nroRegistros;
            AccesoDatos daSQL = new AccesoDatos("con");
            string rpt = daSQL.ejecutarConsulta("select isnull((select STUFF((select '¬'+ convert(varchar,id_mesa)  " +
            "From tbl_mesa where (estado='OCUPADA' or estado='RESERVADA') FOR XML PATH('')),1,1,'')),'~') AS RESULT");
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
                cmdmesas.DataSource = mesas;
                cmdmesas.DisplayMember = "Nombre";
                cmdmesas.ValueMember = "Codigo";
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
        private void frmCambioMesa_Load(object sender, EventArgs e)
        {

        }

        private void btncambio_Click(object sender, EventArgs e)
        {
            if (!cmdmesas.Text.Equals("Seleccione") && !comboBox1.Text.Equals("Seleccione"))
            {
                string idMesaOcupada = cmdmesas.Text.Replace("MESA ", "");
                string idMesaLibre = comboBox1.Text.Replace("MESA ", "");
                AccesoDatos daSQL = new AccesoDatos("con");
                string codigoPedidoOrden = daSQL.ejecutarComando("obtenerIdOrden", "@id_mesa", idMesaOcupada);
                if (codigoPedidoOrden == "")
                {
                    //
                }
                else
                {
                    string[] salida = codigoPedidoOrden.Split('|');
                    codigoPedidoOrden = "";
                    codigoPedidoOrden = salida[0].ToString();
                    string idsMesa = salida[1].ToString();
                    if (idsMesa.Contains(idMesaOcupada))
                    {
                        idsMesa = idsMesa.Replace(idMesaOcupada, idMesaLibre);
                    }
                    string xdata = codigoPedidoOrden + "|" + idMesaOcupada + "|" + idMesaLibre + "|" + idsMesa;
                    string rpta = daSQL.ejecutarComando("upsEditarCombinacionMesas", "@Data", xdata);
                    if (rpta == "true")
                    {
                        men.EditoCorrecto();
                        principal.obtenerListaMesa();
                        this.Close();
                    }
                    else
                    {
                        men.ErrorGuardado();
                    }
                }
            }
        }
        private void btnsalir_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
