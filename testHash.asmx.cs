using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for testHash1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class testHash1 : System.Web.Services.WebService
    {

        public class TableHash
        {
            public string TableName { get; set; }
            public string Hash { get; set; }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public TableHash updateFundedAmt(string noteAddress, string fundedToDate)
        {
            Debug.WriteLine("funding method triggered");
            decimal fundedAmt = decimal.Parse(fundedToDate);

            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            // update funded amount
            string query3 = "update Note set fundedToDate = @fundedToDate where noteAddress = @noteAddress";
            SqlCommand cmd3 = new SqlCommand(query3, con);
            cmd3.Parameters.AddWithValue("@noteAddress", noteAddress);
            cmd3.Parameters.AddWithValue("@fundedToDate", fundedAmt);
            cmd3.ExecuteNonQuery();
            Debug.WriteLine("fundedToDate: " + fundedAmt);

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
