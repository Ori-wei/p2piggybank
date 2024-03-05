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
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string clientID = "";
                if (Session["clientID"] != null)
                {
                    string publicKey = Session["publicKey"].ToString();
                    clientID = Session["clientID"].ToString();
                }

                // SQL Connection
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();
                string query1 = "SELECT status FROM Client WHERE clientID = @clientID";
                SqlCommand cmd1 = new SqlCommand(query1, con);
                cmd1.Parameters.AddWithValue("@clientID", clientID);
                string status = ((string)cmd1.ExecuteScalar())?.Trim();

                if (status == "verified")
                {
                    if(Session["lenderID"] != null)
                    {
                        Invest.Visible = true;
                    }
                    else
                    {
                        Invest.Visible = false;
                        Label4.Text = "Please register as a lender at [My Profile] first.";
                    }
                }
                else
                {
                    Invest.Visible = false;
                    Label4.Text = "Please wait for your identity to be verified.";
                }
                con.Close();
            }

            string noteAddress = Session["noteAddress"].ToString();
            Debug.WriteLine(noteAddress);
            BindAppDetail1(noteAddress);
            BindAppDetail2(noteAddress);
            HiddenField1.Value = noteAddress;

            IntegrityCheck ic = new IntegrityCheck();
            string noteRecord = ic.GetNoteDetails(noteAddress);
            hidden_noteRecord.Value = noteRecord;
        }

        protected void BindAppDetail1(string noteAddress)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Details
            NoteSource1.SelectCommand = "SELECT n.noteAddress, a.financingAmt, a.interestRate, a.Duration, a.creditRating from Note n inner join financingApplication a on n.appID = a.appID where n.noteAddress = @noteAddress";
            NoteSource1.SelectParameters.Clear();
            NoteSource1.SelectParameters.Add("noteAddress", noteAddress);

            //Set Client data as gridview data
            NoteDetail1.DataBind();
        }

        protected void BindAppDetail2(string noteAddress)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            //Retrieve Details
            string query = "select a.financingPurpose, n.listedDate, n.listedEndDate, n.fundedToDate, a.financingAmt from Note n inner join financingApplication a on n.appID = a.appID where n.noteAddress = @noteAddress";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@noteAddress", noteAddress);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    string financingPurpose = reader["financingPurpose"].ToString();
                    string listedDate = reader["listedDate"].ToString();
                    string listedEndDate = reader["listedEndDate"].ToString();
                    decimal fundedToDate = (decimal)reader["fundedToDate"];
                    decimal financingAmt = (decimal)reader["financingAmt"];
                    decimal remainingAmt = financingAmt - fundedToDate;

                    // Create a DataTable and add the values
                    DataTable dt = new DataTable();
                    dt.Columns.Add("financingPurpose");
                    dt.Columns.Add("listedDate");
                    dt.Columns.Add("listedEndDate");
                    dt.Columns.Add("fundedToDate");
                    dt.Columns.Add("remainingAmt");

                    DataRow dr = dt.NewRow();
                    dr["financingPurpose"] = financingPurpose;
                    dr["listedDate"] = listedDate;
                    dr["listedEndDate"] = listedEndDate;
                    dr["fundedToDate"] = fundedToDate;
                    dr["remainingAmt"] = remainingAmt;

                    dt.Rows.Add(dr);

                    //Set Client data as gridview data
                    NoteDetail2.DataSource = dt;
                    NoteDetail2.DataBind();
                }
            }
        }

        protected void Back_Click(object sender, EventArgs e)
        {
            Response.Redirect("1-Client Homepage.aspx");
        }
    }
}