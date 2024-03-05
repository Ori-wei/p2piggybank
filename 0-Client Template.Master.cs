using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Diagnostics;
using System.IO;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class SiteMaster : MasterPage
    {
        private const string ActiveTabKey = "ActiveTabIndex";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["publicKey"] != null)
            {
                navBar.Visible = true;
            }
            else
            {
                navBar.Visible = false;
            }

            if (Session["CurrentUserType"] != null)
            {
                switch (Session["CurrentUserType"]) 
                {
                    case "Borrower":
                        {
                            borrowerTabToggle();
                            break;
                        }
                    case "Lender":
                        {
                            lenderTabToggle();
                            break;
                        }
                }
            }

            if (Session["CurrentUserType"] == null)
            {
                lenderTabToggle();
            }

        }

        protected void borrowerTabToggle()
        {
            //MultiView1.ActiveViewIndex = 0;
            ViewState[ActiveTabKey] = 0;
            UpdateTabClasses();

            borrowerLinks.Style["display"] = "block";  // Show borrower links
            lenderLinks.Style["display"] = "none";     // Hide lender links
        }
        protected void borrowerTab_Click(object sender, EventArgs e)
        {
            Session["CurrentUserType"] = "Borrower";
            borrowerTabToggle();
        }

        protected void lenderTabToggle()
        {
            //MultiView1.ActiveViewIndex = 1;
            ViewState[ActiveTabKey] = 1;
            UpdateTabClasses();

            lenderLinks.Style["display"] = "block";    // Show lender links
            borrowerLinks.Style["display"] = "none";   // Hide borrower links
        }

        protected void lenderTab_Click(object sender, EventArgs e)
        {
            Session["CurrentUserType"] = "Lender";
            lenderTabToggle();
        }

        private void UpdateTabClasses()
        {
            // Retrieve the active tab index from ViewState
            int activeTabIndex = Convert.ToInt32(ViewState[ActiveTabKey]);

            // Remove all active-tab classes
            borrowerTab.CssClass = borrowerTab.CssClass.Replace("active-tab", "");
            lenderTab.CssClass = lenderTab.CssClass.Replace("active-tab", "");

            // Add the active-tab class to the currently active tab
            switch (activeTabIndex)
            {
                case 0:
                    borrowerTab.CssClass += " active-tab";
                    break;
                case 1:
                    lenderTab.CssClass += " active-tab";
                    break;
            }
        }

        [WebMethod(EnableSession = true)]
        public static void SetSessionPublicKey(string publicKey)
        {
            HttpContext.Current.Session["publicKey"] = publicKey;
        }

    }
}