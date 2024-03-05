using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string clientID = "";

            Debug.WriteLine("Testing session on Homepage");
            if (Session["publicKey"] != null)
            {
                Debug.WriteLine(Session["publicKey"].ToString());
            }

            if (Session["clientID"] != null)
            {
                clientID = Session["clientID"].ToString();
                Debug.WriteLine(clientID);
            }

            Debug.WriteLine("Testing session on Homepage completed");

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Class Details
            string query1 = "select n.noteAddress, a.creditRating, n.listedEndDate, a.interestRate, a.Duration, " +
                "a.financingAmt, n.fundedToDate from Note n inner join financingApplication a on n.appID = a.appID " +
                "where noteStatus = 'funding'";
            SqlCommand cmd = new SqlCommand(query1, con);

            DataTable dt = new DataTable();
            dt.Columns.Add("noteAddress");
            dt.Columns.Add("creditRating");
            dt.Columns.Add("listedEndDate");
            dt.Columns.Add("interestRate");
            dt.Columns.Add("Duration");
            dt.Columns.Add("financingAmt");
            dt.Columns.Add("fundedToDate");
            dt.Columns.Add("remainingAmt");

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string noteAddress = reader["noteAddress"].ToString();
                    string creditRating = reader["creditRating"].ToString();
                    string listedEndDate = reader["listedEndDate"].ToString();
                    string interestRate = reader["interestRate"].ToString();
                    string Duration = reader["Duration"].ToString();
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    decimal fundedToDate = (decimal)reader["fundedToDate"];

                    // Calculate remaining amount
                    decimal remainingAmt = financingAmt - fundedToDate;
                    Debug.WriteLine(remainingAmt);

                    DataRow dr = dt.NewRow();
                    dr["noteAddress"] = noteAddress;
                    dr["creditRating"] = creditRating;
                    dr["listedEndDate"] = listedEndDate;
                    dr["interestRate"] = interestRate;
                    dr["Duration"] = Duration;
                    dr["financingAmt"] = financingAmt;
                    dr["fundedToDate"] = fundedToDate;
                    dr["remainingAmt"] = remainingAmt;

                    dt.Rows.Add(dr);
                }
            }

            //Set Client data as gridview data
            noteTable.DataSource = dt;
            noteTable.DataBind();
        }

        protected void ShowNote(object sender, CommandEventArgs e)
        {
            // get noteAddress
            string noteAddress = e.CommandArgument.ToString();
            Debug.WriteLine(noteAddress);

            Session["noteAddress"] = noteAddress;
            Debug.WriteLine(Session["noteAddress"]);

            // Next page
            Response.Redirect("2-Note Detail.aspx");
        }

    }
}