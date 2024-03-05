using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm9 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["publicKey"] != null)
            {
                string publicKey = Session["publicKey"].ToString();
            }
        }

        protected void nextBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("5-Borrower My Application.aspx");
        }
    }
}