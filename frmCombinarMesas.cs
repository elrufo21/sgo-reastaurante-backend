using System;
using System.Collections.Generic;
using System.Windows.Forms;
using MegaRosita.Capa.Comun;
using MegaRosita.Capa.Entidades;

namespace MegaRosita.Capa.Aplicacion
{
    public partial class FrmCombinarMesas : Form
    {
        public ControlMesas principal;
        public string xPersonal {get; set;}
        public FrmCombinarMesas(ControlMesas frm)
        {
            InitializeComponent();
            this.principal = frm;
            listarMesas();
        }
        public void listarMesas()
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
                cmdmesas.DataSource = mesas;
                cmdmesas.DisplayMember = "Nombre";
                cmdmesas.ValueMember = "Codigo";
                listBox1.Items.Clear();
            }
        }
        private void FrmCombinarMesas_Load(object sender, EventArgs e)
        {

        }
        private void cmdmesas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!cmdmesas.Text.Equals("Seleccione"))
            {
                if (listBox1.FindString(cmdmesas.Text) != -1)
                {
                    MessageBox.Show("La " + cmdmesas.Text + " ya fue selecionada", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    listBox1.Items.Add(cmdmesas.Text);
                }
            }
        }

        private void btnquitar_Click(object sender, EventArgs e)
        {
            if (this.listBox1.SelectedIndex >= 0)
                this.listBox1.Items.RemoveAt(this.listBox1.SelectedIndex);
        }

        private void btnsalir_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnunion_Click(object sender, EventArgs e)
        {
            int contador = 0;
            string data = "";
            for (int i = 0; i < listBox1.Items.Count; i++)
            {
                string mesa = listBox1.Items[i].ToString().Replace("MESA ", "");
                data += mesa + ',';
                contador++;
            }
            if (contador== 1)
            {
                MessageBox.Show("Si Selecciono solo una mesa...Realicelo por el panel principal", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else if (contador >= 2)
            {
                string codigoPedidoOrden = "0";
                string tipoRegistro = "-";
                FrmPedidos form = new FrmPedidos(data.Substring(0, data.Length - 1), principal, false, codigoPedidoOrden, tipoRegistro);
                form.xPersonal = xPersonal;
                form.ShowDialog();
                this.Close();
            }
            else
            {
                MessageBox.Show("Seleccione mas de una mesa", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }
    }
}
