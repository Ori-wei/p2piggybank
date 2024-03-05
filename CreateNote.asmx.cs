using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for CreateNote
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class CreateNote : System.Web.Services.WebService
    {
        public class TableHash
        {
            public string TableName1 { get; set; }
            public string Hash1 { get; set; }
            public string Pkey1 { get; set; }
            public string TableName2 { get; set; }
            public string Hash2 { get; set; }
            public string Pkey2 { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public TableHash SetNoteAddress(string noteAddress, string signature)
        {
            try
            {
                string appID = Session["appID"].ToString();

                // SQL Connection
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
                con.Open();

                //loan Duration, interestRate, financingAmt
                int loanDuration = 0;
                decimal interestRate = 0;
                decimal financingAmount = 0;
                string query = "select Duration, interestRate, financingAmt from financingApplication where appID = @AppID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AppID", appID);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        loanDuration = (int)reader["Duration"];
                        interestRate = (decimal)reader["interestRate"];
                        financingAmount = (decimal)reader["financingAmt"];
                    }
                }

                //repaymentAmt
                decimal repaymentAmt = CalculateRepaymentAmount(interestRate, financingAmount);

                //ListedDate
                DateTime listedDate = DateTime.Now;

                //ListedEndDate
                //DateTime listedEndDate = listedDate.AddMonths(2);
                DateTime listedEndDate = listedDate.AddMinutes(5);

                // fundedToDate
                decimal fundedToDate = 0;

                //repaymentDate
                //DateTime repaymentDate = listedEndDate.AddMonths(loanDuration);
                DateTime repaymentDate = listedEndDate.AddMinutes(loanDuration);

                //noteStatus
                string noteStatus = "funding";

                //create new note
                string query2 = "INSERT INTO Note (noteAddress, listedDate, listedEndDate, fundedToDate, repaymentDate, repaymentAmt, noteStatus, appID) " +
                    "VALUES (@noteAddress, @listedDate, @listedEndDate, @fundedToDate, @repaymentDate, @repaymentAmt, @noteStatus, @appID)";
                SqlCommand cmd2 = new SqlCommand(query2, con);
                cmd2.Parameters.AddWithValue("@noteAddress", noteAddress);
                cmd2.Parameters.AddWithValue("@listedDate", listedDate);
                cmd2.Parameters.AddWithValue("@listedEndDate", listedEndDate);
                cmd2.Parameters.AddWithValue("@fundedToDate", fundedToDate);
                cmd2.Parameters.AddWithValue("@repaymentDate", repaymentDate);
                cmd2.Parameters.AddWithValue("@repaymentAmt", repaymentAmt);
                cmd2.Parameters.AddWithValue("@noteStatus", noteStatus);
                cmd2.Parameters.AddWithValue("@appID", appID);
                cmd2.ExecuteNonQuery();

                IntegrityCheck checkNote = new IntegrityCheck();
                string note = checkNote.GetNoteDetails(noteAddress);
                string hashNote = IntegrityCheck.ComputeSha256Hash(note);
                Debug.WriteLine("The hash for " + note + " is " + hashNote);

                // update application status: accepted
                string query3 = "UPDATE financingApplication set status = 'accepted', signature = @signature where appID = @AppID";
                SqlCommand cmd3 = new SqlCommand(query3, con);
                cmd3.Parameters.AddWithValue("@signature", signature);
                cmd3.Parameters.AddWithValue("@AppID", appID);
                cmd3.ExecuteNonQuery();

                Debug.WriteLine("============= Check create note data =============");
                Debug.WriteLine("listed end date: " + listedDate);
                Debug.WriteLine("listed end date: " + listedEndDate);
                Debug.WriteLine("repayment date: " + repaymentDate);

                IntegrityCheck checkApp = new IntegrityCheck();
                string app = checkNote.GetAppDetails(appID);
                string hashApp = IntegrityCheck.ComputeSha256Hash(app);
                Debug.WriteLine("The hash for " + app + " is " + hashApp);

                con.Close();

                return new TableHash
                {
                    TableName1 = "App",
                    Hash1 = hashApp,
                    Pkey1 = appID,
                    TableName2 = "Note",
                    Hash2 = hashNote,
                    Pkey2 = noteAddress
                };
            }
            catch(Exception ex)
            {
                Debug.WriteLine(ex);
                throw;
            }
        }

        private decimal CalculateRepaymentAmount(decimal interestRate, decimal financingAmount)
        {
            decimal interest = interestRate * financingAmount;
            decimal repaymentAmount = interest + financingAmount;
            repaymentAmount = Math.Round(repaymentAmount, 2, MidpointRounding.AwayFromZero);
            return repaymentAmount;
        }
    }
}
