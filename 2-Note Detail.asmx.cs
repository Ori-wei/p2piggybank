using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;


namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for CalculateMaxValue
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class CalculateMaxValue : System.Web.Services.WebService
    {
        public class TableHash
        {
            public string TableName { get; set; }
            public string Hash { get; set; }
        }


        [WebMethod]
        public decimal GetMaxInvestmentAmount(string noteAddress)
        {
            decimal financingAmt = 0;
            decimal fundedToDate = 0;

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "select n.fundedToDate, a.financingAmt from Note n inner join financingApplication a on n.appID = a.appID where n.noteAddress = @noteAddress";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@noteAddress", noteAddress);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    fundedToDate = (decimal)reader["fundedToDate"];
                    financingAmt = (decimal)reader["financingAmt"];
                }

                Debug.WriteLine(financingAmt);
                Debug.WriteLine(fundedToDate);
                Debug.WriteLine(financingAmt - fundedToDate);
                return Math.Round((financingAmt - fundedToDate), 2, MidpointRounding.AwayFromZero);
            }

        }

        [WebMethod]
        public decimal CalculateReturn(string noteAddress, decimal amount)
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "select a.interestRate, a.financingAmt from Note n inner join financingApplication a on n.appID = a.appID where n.noteAddress = @noteAddress";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@noteAddress", noteAddress);

            decimal interestRate = 0;
            decimal financingAmt = 0;

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    // Assuming the data types are string for dates, decimal for amounts and interest rates
                    interestRate = (decimal)reader["interestRate"];
                    financingAmt = (decimal)reader["financingAmt"];
                }
            }
            Debug.WriteLine("===========Display values===============");
            Debug.WriteLine(interestRate);
            Debug.WriteLine(financingAmt);

            con.Close();

            // calculate expected return
            decimal profit = amount * interestRate;
            return Math.Round(amount + profit, 2, MidpointRounding.AwayFromZero);
        }

        [WebMethod(EnableSession = true)]
        public void insertInvestedNote(string noteAddress, string amount, string signature)
        {
            Debug.WriteLine("investedNote method triggered");
            decimal investedAmount = decimal.Parse(amount);

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            string query = "select count(*) from InvestedNote";
            SqlCommand cmd = new SqlCommand(query, con);
            int totalInvestedNote = Convert.ToInt32(cmd.ExecuteScalar());

            int investedNo = totalInvestedNote + 1;
            string num = investedNo.ToString();
            string investedID = num.PadLeft(3, '0');

            // lender ID
            string lenderID = Session["lenderID"].ToString();

            // return amount
            string query2 = "SELECT a.interestRate from Note n inner join financingApplication a on n.appID = a.appID where n.noteAddress = @noteAddress";
            SqlCommand cmdCheck2 = new SqlCommand(query2, con);
            cmdCheck2.Parameters.AddWithValue("@noteAddress", noteAddress);
            decimal interestRate = (decimal)cmdCheck2.ExecuteScalar();

            // calculate expected return
            decimal profit = investedAmount + (investedAmount * interestRate);
            Debug.WriteLine(interestRate);

            // insert invested note
            string query3 = "insert into InvestedNote (investedNoteID, lenderID, noteAddress, investedAmt, returnAmt, signature) values(@investedID, @lenderID, @noteAddress, @investedAmount, @returnAmt, @signature)";
            SqlCommand cmd3 = new SqlCommand(query3, con);
            cmd3.Parameters.AddWithValue("@investedID", "I" + investedID);
            cmd3.Parameters.AddWithValue("@lenderID", lenderID);
            cmd3.Parameters.AddWithValue("@noteAddress", noteAddress);
            cmd3.Parameters.AddWithValue("@investedAmount", investedAmount);
            cmd3.Parameters.AddWithValue("@returnAmt", profit);
            cmd3.Parameters.AddWithValue("@signature", signature);
            cmd3.ExecuteNonQuery();
            Debug.WriteLine("investedAmount: " + investedAmount);

            con.Close();
        }

        [WebMethod]
        public TableHash updateFundedAmt(string noteAddress, string fundedToDate)
        {
            Debug.WriteLine("funding method triggered");
            decimal fundedAmt = decimal.Parse(fundedToDate);
            DateTime dtNow = DateTime.Now;

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // update funded amount
            string query3 = "update Note set fundedToDate = @fundedToDate, updateDate = @updateDate where noteAddress = @noteAddress";
            SqlCommand cmd3 = new SqlCommand(query3, con);
            cmd3.Parameters.AddWithValue("@noteAddress", noteAddress);
            cmd3.Parameters.AddWithValue("@fundedToDate", fundedAmt);
            cmd3.Parameters.AddWithValue("@updateDate", dtNow);
            cmd3.ExecuteNonQuery();
            Debug.WriteLine("fundedToDate: " + fundedAmt);
            Debug.WriteLine("updateDate: " + dtNow);

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

        [WebMethod]
        public TableHash updateDisbursement(string noteAddress, DateTime listedEndDateForDb, DateTime repaymentDateForDb)
        {
            Debug.WriteLine("disbursement method triggered");

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // if funding goal reached
            string query2 = "update Note set listedEndDate = @listedEndDate, repaymentDate = @repaymentDate, noteStatus = 'disbursed' where noteAddress = @noteAddress";
            SqlCommand cmd2 = new SqlCommand(query2, con);
            cmd2.Parameters.AddWithValue("@noteAddress", noteAddress);
            cmd2.Parameters.AddWithValue("@listedEndDate", listedEndDateForDb);
            cmd2.Parameters.AddWithValue("@repaymentDate", repaymentDateForDb);
            cmd2.ExecuteNonQuery();

            Debug.WriteLine("============= Check disburse data =============");
            Debug.WriteLine("updated listedEndDate: " + listedEndDateForDb);
            Debug.WriteLine("updated repaymentDate: " + repaymentDateForDb);
            Debug.WriteLine("updated noteStatus: disbursed");
            
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
