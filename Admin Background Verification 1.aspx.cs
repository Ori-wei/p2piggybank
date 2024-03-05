using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            DataTable dt = new DataTable();
            dt.Columns.Add("clientID");
            dt.Columns.Add("fullName");
            dt.Columns.Add("DoB");
            dt.Columns.Add("Gender");
            dt.Columns.Add("contactNo");
            dt.Columns.Add("publicKey");

            //Retrieve User Details
            string query2 = "select clientID, fullName, DoB, Gender, contactNo, publicKey from Client where status = 'pending'";
            SqlCommand cmd2 = new SqlCommand(query2, con);

            using (SqlDataReader reader = cmd2.ExecuteReader())
            {
                while (reader.Read())
                {
                    string clientID = reader["clientID"].ToString();
                    string fullName = reader["fullName"].ToString();
                    string DoB = reader["DoB"].ToString();
                    string Gender = reader["Gender"].ToString();
                    string contactNo = reader["contactNo"].ToString();
                    string publicKey = reader["publicKey"].ToString();

                    DataRow dr = dt.NewRow();
                    dr["clientID"] = clientID;
                    dr["fullName"] = fullName;
                    dr["DoB"] = DoB;
                    dr["Gender"] = Gender;
                    dr["contactNo"] = contactNo;
                    dr["publicKey"] = publicKey;

                    dt.Rows.Add(dr);
                }
            }

            //Set Client data as gridview data
            verificationTB.DataSource = dt;
            verificationTB.DataBind();
        }

        protected void NextPage(object sender, CommandEventArgs e)
        {
            // use client id
            string clientID = e.CommandArgument.ToString();

            // check client type
            CheckBorrower(clientID);
            CheckLender(clientID);

            Session["clientID"] = clientID;
            Debug.WriteLine(Session["clientID"]);

            // Next page
            Response.Redirect("Admin Background Verification 2.aspx");
        }

        protected void CheckBorrower(string clientID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if user is borrower
            string query = "select borrowerID from Borrower where clientID = '" + clientID + "'";
            SqlCommand cmdCheck = new SqlCommand(query, con);
            string borrowerID = (string)cmdCheck.ExecuteScalar();

            // If it does not exist, insert it
            if (borrowerID != null)
            {
                Session["borrowerID"] = borrowerID;
                Debug.WriteLine(Session["borrowerID"]);
            }

        }

        protected void CheckLender(string clientID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // Check if user is borrower
            string query = "select lenderID from Lender where clientID = '" + clientID + "'";
            SqlCommand cmdCheck = new SqlCommand(query, con);
            string lenderID = (string)cmdCheck.ExecuteScalar();

            // If it does not exist, insert it
            if (lenderID != null)
            {
                Session["lenderID"] = lenderID;
                Debug.WriteLine(Session["lenderID"]);
            }

        }
    }
}