using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web.Services;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    /// <summary>
    /// Summary description for Admin_Integrity_Check
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Admin_Integrity_Check : System.Web.Services.WebService
    {
        public class ComparisonResult
        {
            public string tableName { get; set; }
            public string primaryKey { get; set; }
            public string hashContract { get; set; }
            public string hashDB { get; set; }
            public string comparisonResult { get; set; }

            public string toString()
            {
                return (tableName + primaryKey + hashContract + hashDB + comparisonResult);
            }
        }

        [WebMethod]
        public string AllocateFunction(string tableName, string primaryKey)
        {
            Debug.WriteLine("Db function triggered");
            Debug.WriteLine(primaryKey);
            Debug.WriteLine(tableName);
            string dataFromDb = "";
            string hashFromDb = "";
            IntegrityCheck ic = new IntegrityCheck();

            try
            {
                switch (tableName)
                {
                    case "Client":
                        dataFromDb = ic.GetClientDetails(primaryKey);
                        break;
                    case "Borrower":
                        dataFromDb = ic.GetBorrowerDetails(primaryKey);
                        break;
                    case "Lender":
                        dataFromDb = ic.GetLenderDetails(primaryKey);
                        break;
                    case "App":
                        dataFromDb = ic.GetAppDetails(primaryKey);
                        break;
                    case "Note":
                        dataFromDb = ic.GetNoteDetails(primaryKey);
                        break;
                }

                Debug.WriteLine(dataFromDb);
                hashFromDb = IntegrityCheck.ComputeSha256Hash(dataFromDb);
                Debug.WriteLine(hashFromDb);
                return hashFromDb;
            }catch (Exception e)
            {
                throw e;
            }
        }

        [WebMethod(EnableSession = true)]
        public void UpdateComparisonResults(ComparisonResult table1, ComparisonResult table2, ComparisonResult table3, ComparisonResult table4, ComparisonResult table5)
        {
            Debug.WriteLine("Test if data is passed to asmx");
            Debug.WriteLine(table1 + table1.toString());
            Debug.WriteLine(table2 + table2.toString());
            Debug.WriteLine(table3 + table3.toString());
            Debug.WriteLine(table4 + table4.toString());
            Debug.WriteLine(table5 + table5.toString());

            // Assume you have a session or application-level list to hold the results
            List<ComparisonResult> results1 = Session["ComparisonResults1"] as List<ComparisonResult>;
            List<ComparisonResult> results2 = Session["ComparisonResults2"] as List<ComparisonResult>;
            List<ComparisonResult> results3 = Session["ComparisonResults3"] as List<ComparisonResult>;
            List<ComparisonResult> results4 = Session["ComparisonResults4"] as List<ComparisonResult>;
            List<ComparisonResult> results5 = Session["ComparisonResults5"] as List<ComparisonResult>;
            if (results1 == null)
            {
                results1 = new List<ComparisonResult>();
            }
            if (results2 == null)
            {
                results2 = new List<ComparisonResult>();
            }
            if (results3 == null)
            {
                results3 = new List<ComparisonResult>();
            }
            if (results4 == null)
            {
                results4 = new List<ComparisonResult>();
            }
            if (results5 == null)
            {
                results5 = new List<ComparisonResult>();
            }
            
            results1.Add(new ComparisonResult
            {
                tableName = table1.tableName,
                primaryKey = table1.primaryKey,
                hashContract = table1.hashContract,
                hashDB = table1.hashDB,
                comparisonResult = table1.comparisonResult
            });
            results2.Add(new ComparisonResult
            {
                tableName = table2.tableName,
                primaryKey = table2.primaryKey,
                hashContract = table2.hashContract,
                hashDB = table2.hashDB,
                comparisonResult = table2.comparisonResult
            });
           results3.Add(new ComparisonResult
            {
               tableName = table3.tableName,
               primaryKey = table3.primaryKey,
               hashContract = table3.hashContract,
               hashDB = table3.hashDB,
               comparisonResult = table3.comparisonResult
           });
            results4.Add(new ComparisonResult
            {
                tableName = table4.tableName,
                primaryKey = table4.primaryKey,
                hashContract = table4.hashContract,
                hashDB = table4.hashDB,
                comparisonResult = table4.comparisonResult
            });
            results5.Add(new ComparisonResult
            {
                tableName = table5.tableName,
                primaryKey = table5.primaryKey,
                hashContract = table5.hashContract,
                hashDB = table5.hashDB,
                comparisonResult = table5.comparisonResult
            });

            foreach (ComparisonResult result in results1)
            {
                Debug.WriteLine("Check if it's in the list already");
                Debug.WriteLine("-----------------------------");
                Debug.WriteLine("TableName: " + result.tableName);
                Debug.WriteLine("PrimaryKey: " + result.primaryKey);
                Debug.WriteLine("HashFromContract: " + result.hashContract);
                Debug.WriteLine("HashFromDB: " + result.hashDB);
                Debug.WriteLine("CompareResult: " + result.comparisonResult);
                Debug.WriteLine("-----------------------------");
            }
            foreach (ComparisonResult result in results2)
            {
                Debug.WriteLine("Check if it's in the list already");
                Debug.WriteLine("-----------------------------");
                Debug.WriteLine("TableName: " + result.tableName);
                Debug.WriteLine("PrimaryKey: " + result.primaryKey);
                Debug.WriteLine("HashFromContract: " + result.hashContract);
                Debug.WriteLine("HashFromDB: " + result.hashDB);
                Debug.WriteLine("CompareResult: " + result.comparisonResult);
                Debug.WriteLine("-----------------------------");
            }
            foreach (ComparisonResult result in results3)
            {
                Debug.WriteLine("Check if it's in the list already");
                Debug.WriteLine("-----------------------------");
                Debug.WriteLine("TableName: " + result.tableName);
                Debug.WriteLine("PrimaryKey: " + result.primaryKey);
                Debug.WriteLine("HashFromContract: " + result.hashContract);
                Debug.WriteLine("HashFromDB: " + result.hashDB);
                Debug.WriteLine("CompareResult: " + result.comparisonResult);
                Debug.WriteLine("-----------------------------");
            }
            foreach (ComparisonResult result in results4)
            {
                Debug.WriteLine("Check if it's in the list already");
                Debug.WriteLine("-----------------------------");
                Debug.WriteLine("TableName: " + result.tableName);
                Debug.WriteLine("PrimaryKey: " + result.primaryKey);
                Debug.WriteLine("HashFromContract: " + result.hashContract);
                Debug.WriteLine("HashFromDB: " + result.hashDB);
                Debug.WriteLine("CompareResult: " + result.comparisonResult);
                Debug.WriteLine("-----------------------------");
            }
            foreach (ComparisonResult result in results5)
            {
                Debug.WriteLine("Check if it's in the list already");
                Debug.WriteLine("-----------------------------");
                Debug.WriteLine("TableName: " + result.tableName);
                Debug.WriteLine("PrimaryKey: " + result.primaryKey);
                Debug.WriteLine("HashFromContract: " + result.hashContract);
                Debug.WriteLine("HashFromDB: " + result.hashDB);
                Debug.WriteLine("CompareResult: " + result.comparisonResult);
                Debug.WriteLine("-----------------------------");
            }
            
            Session["ComparisonResults1"] = results1;
            Session["ComparisonResults2"] = results2;
            Session["ComparisonResults3"] = results3;
            Session["ComparisonResults4"] = results4;
            Session["ComparisonResults5"] = results5;
            Debug.WriteLine("Comparison  Results 1-5");
            Debug.WriteLine(Session["ComparisonResults1"]);
            Debug.WriteLine(Session["ComparisonResults2"]);
            Debug.WriteLine(Session["ComparisonResults3"]);
            Debug.WriteLine(Session["ComparisonResults4"]);
            Debug.WriteLine(Session["ComparisonResults5"]);
        }

        [WebMethod]
        public string CompareNoteHash()
        {
            // SQL Connection
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            con.Open();

            IntegrityCheck IC = new IntegrityCheck();
            string note = IC.GetNoteDetailsHash();
            string hashNote = IntegrityCheck.ComputeSha256Hash(note);

            Debug.WriteLine("The hash for " + note + " is " + hashNote);

            return hashNote;
        }
    }
}
