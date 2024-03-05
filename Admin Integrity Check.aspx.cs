using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public partial class WebForm21 : System.Web.UI.Page
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


        protected void Page_Load(object sender, EventArgs e)
        {
            BindComparisonResults();
        }

        private void BindComparisonResults()
        {
            var sourceList1 = Session["ComparisonResults1"] as List<Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.Admin_Integrity_Check.ComparisonResult>;
            var results1 = sourceList1?.Select(item => new Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21.ComparisonResult
            {
                tableName = item.tableName,
                primaryKey = item.primaryKey,
                hashContract = item.hashContract,
                hashDB = item.hashDB,
                comparisonResult = item.comparisonResult
            }).ToList();
            var sourceList2 = Session["ComparisonResults2"] as List<Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.Admin_Integrity_Check.ComparisonResult>;
            var results2 = sourceList2?.Select(item => new Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21.ComparisonResult
            {
                tableName = item.tableName,
                primaryKey = item.primaryKey,
                hashContract = item.hashContract,
                hashDB = item.hashDB,
                comparisonResult = item.comparisonResult
            }).ToList();
            var sourceList3 = Session["ComparisonResults3"] as List<Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.Admin_Integrity_Check.ComparisonResult>;
            var results3 = sourceList3?.Select(item => new Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21.ComparisonResult
            {
                tableName = item.tableName,
                primaryKey = item.primaryKey,
                hashContract = item.hashContract,
                hashDB = item.hashDB,
                comparisonResult = item.comparisonResult
            }).ToList();
            var sourceList4 = Session["ComparisonResults4"] as List<Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.Admin_Integrity_Check.ComparisonResult>;
            var results4 = sourceList4?.Select(item => new Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21.ComparisonResult
            {
                tableName = item.tableName,
                primaryKey = item.primaryKey,
                hashContract = item.hashContract,
                hashDB = item.hashDB,
                comparisonResult = item.comparisonResult
            }).ToList();
            var sourceList5 = Session["ComparisonResults5"] as List<Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.Admin_Integrity_Check.ComparisonResult>;
            var results5 = sourceList5?.Select(item => new Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21.ComparisonResult
            {
                tableName = item.tableName,
                primaryKey = item.primaryKey,
                hashContract = item.hashContract,
                hashDB = item.hashDB,
                comparisonResult = item.comparisonResult
            }).ToList();

            Debug.WriteLine("result retrived: " + results1);
            Debug.WriteLine("result retrived: " + results2);
            Debug.WriteLine("result retrived: " + results3);
            Debug.WriteLine("result retrived: " + results4);
            Debug.WriteLine("result retrived: " + results5);

            var sessionType = Session["ComparisonResults1"]?.GetType().ToString() ?? "null";
            Debug.WriteLine($"Session object type for ComparisonResults1: {sessionType}");

            var combinedResults = new List<ComparisonResult>();
            if (results1 != null) combinedResults.AddRange(results1);
            if (results2 != null) combinedResults.AddRange(results2);
            if (results3 != null) combinedResults.AddRange(results3);
            if (results4 != null) combinedResults.AddRange(results4);
            if (results5 != null) combinedResults.AddRange(results5);

            // Then bind the combined list to the GridView
            if (combinedResults.Any())
            {
                Debug.WriteLine("Binding combined results");
                ComparisonResults.DataSource = combinedResults;
                ComparisonResults.DataBind();
                OkButton.Visible = true;
            }
            else
            {
                Debug.WriteLine("No integrity check records found.");
            }
        }
/*
        [WebMethod(EnableSession = true)]
        public static void UpdateComparisonResults(string tableName, string hashContract, string hashDB, string comparisonResult)
        {
            Debug.WriteLine("Test if data is passed to aspx");
            Debug.WriteLine("Test if data is passed to aspx");
            Debug.WriteLine(tableName);
            Debug.WriteLine(hashContract);
            Debug.WriteLine(hashDB);
            Debug.WriteLine(comparisonResult);

            // Assume you have a session or application-level list to hold the results
            //List<ComparisonResult> results = Session["ComparisonResults"] as List<ComparisonResult>;
            List<ComparisonResult> results = HttpContext.Current.Session["ComparisonResults"] as List<ComparisonResult>;

            if (results == null)
            {
                results = new List<ComparisonResult>();
            }

            results.Add(new ComparisonResult
            {
                tableName = tableName,
                hashContract = hashContract,
                hashDB = hashDB,
                comparisonResult = comparisonResult
            });

            HttpContext.Current.Session["ComparisonResults"] = results;
        }*/

        protected void OkButton_Click(object sender, EventArgs e)
        {
            OkButton.Visible = false;
            // Clear the session and rebind the GridView (or refresh the page)
            //Session["ComparisonResults"] = new List<ComparisonResult>();
            //BindComparisonResults(); // Rebind or refresh the page
            //var emptyList = new List<ComparisonResult>();

            Session["ComparisonResults1"] = null;
            Session["ComparisonResults2"] = null;
            Session["ComparisonResults3"] = null;
            Session["ComparisonResults4"] = null;
            Session["ComparisonResults5"] = null;

            // Now clear and rebind the GridView
            ComparisonResults.DataSource = null;
            ComparisonResults.DataBind();
            Response.Redirect("Admin Integrity Check.aspx");
        }
    }
}