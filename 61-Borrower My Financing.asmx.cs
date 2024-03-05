using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for _61_Borrower_My_Financing
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class _61_Borrower_My_Financing : System.Web.Services.WebService
    {
        public class TableHash
        {
            public string TableName { get; set; }
            public string Hash { get; set; }
        }

        [WebMethod]
        public string setRepayable(string noteAddress)
        {
            Debug.WriteLine("set repayable method triggered");

            decimal totalRepayable = 0;
            DateTime? repaymentDT = null;
            decimal repaymentAmount = 0;

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();
            string query1 = "select repaymentDate, repaymentAmt from Note where noteAddress = @noteAddress";
            SqlCommand cmd = new SqlCommand(query1, con);
            cmd.Parameters.AddWithValue("@noteAddress", noteAddress);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    repaymentDT = (DateTime)reader["repaymentDate"];
                    repaymentAmount = (decimal)reader["repaymentAmt"];
                }
                Debug.WriteLine(repaymentDT);
                Debug.WriteLine(repaymentAmount);

                Debug.WriteLine("Current Date: " + DateTime.Now.Date);
                Debug.WriteLine("Repayment Date: " + repaymentDT.Value.Date);
                totalRepayable = repaymentAmount;
                
            }
            Debug.WriteLine(totalRepayable);
            con.Close();
            string repayable = totalRepayable.ToString();
            return repayable;
        }

        [WebMethod]
        public TableHash updateNoteComplete(string noteAddress)
        {
            Debug.WriteLine("update note complete method triggered");
            Debug.WriteLine(noteAddress);
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();
            string query1 = "update Note set noteStatus = 'completed' where noteAddress = @noteAddress";
            SqlCommand cmd = new SqlCommand(query1, con);
            cmd.Parameters.AddWithValue("@noteAddress", noteAddress);
            cmd.ExecuteNonQuery();
            Debug.WriteLine("update note complete method Completed");

            IntegrityCheck checkNote = new IntegrityCheck();
            string note = checkNote.GetNoteDetails(noteAddress);
            string hashNote = IntegrityCheck.ComputeSha256Hash(note);
            Debug.WriteLine("The hash for " + note + " is " + hashNote);

            con.Close();

            return new TableHash
            {
                TableName = "Note",
                Hash = hashNote
            };
        }
    }
}
