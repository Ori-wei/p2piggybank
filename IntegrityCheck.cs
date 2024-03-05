using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Security.Cryptography;
using System.Text;
using Nethereum.Web3;
using Nethereum.Web3.Accounts;
using Nethereum.Hex.HexTypes;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Configuration;
using System.Diagnostics;

namespace Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform
{
    public class IntegrityCheck
    {
        private static string passphrase = "FYPp2plendingsystem23!";

        public static string ComputeSha256Hash(string rawData)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(rawData));

                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        public string GetNoteDetails(string noteAddress)
        {
            // Initialization of variables
            DateTime? listedDate = null;
            DateTime? listedEndDate = null;
            decimal fundedToDate = 0;
            DateTime? repaymentDate = null;
            decimal repaymentAmt = 0;
            string noteStatus = null;
            string appID = null;

            // DB Connection and Query
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "select * from Note where noteAddress = @noteAddress";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@noteAddress", noteAddress);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Your existing logic for reading the data
                        listedDate = reader["listedDate"] != DBNull.Value ? (DateTime?)reader["listedDate"] : null;
                        listedEndDate = reader["listedEndDate"] != DBNull.Value ? (DateTime?)reader["listedEndDate"] : null;
                        fundedToDate = reader.IsDBNull(reader.GetOrdinal("fundedToDate")) ? 0 : (decimal)reader["fundedToDate"];
                        repaymentDate = reader["repaymentDate"] != DBNull.Value ? (DateTime?)reader["repaymentDate"] : null;
                        repaymentAmt = reader.IsDBNull(reader.GetOrdinal("repaymentAmt")) ? 0 : (decimal)reader["repaymentAmt"];
                        noteStatus = reader.IsDBNull(reader.GetOrdinal("noteStatus")) ? null : (string)reader["noteStatus"];
                        appID = reader.IsDBNull(reader.GetOrdinal("appID")) ? null : (string)reader["appID"];
                    }
                }
            }  // Automatic disposal of connection
            return $"{noteAddress}-{listedDate}-{listedEndDate}-{fundedToDate}-{repaymentDate}-{repaymentAmt}-{noteStatus}-{appID}";
        }

        public string GetNoteDetailsHash()
        {
            // Initialization of variables
            string noteAddress = null;
            DateTime? listedDate = null;
            DateTime? listedEndDate = null;
            decimal fundedToDate = 0;
            DateTime? repaymentDate = null;
            decimal repaymentAmt = 0;
            string noteStatus = null;
            string appID = null;

            // DB Connection and Query
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "SELECT * FROM Note WHERE updateDate = (SELECT MAX(updateDate) FROM Note);";
                SqlCommand cmd = new SqlCommand(query, con);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Your existing logic for reading the data
                        noteAddress = reader.IsDBNull(reader.GetOrdinal("noteAddress")) ? null : (string)reader["noteAddress"];
                        listedDate = reader["listedDate"] != DBNull.Value ? (DateTime?)reader["listedDate"] : null;
                        listedEndDate = reader["listedEndDate"] != DBNull.Value ? (DateTime?)reader["listedEndDate"] : null;
                        fundedToDate = reader.IsDBNull(reader.GetOrdinal("fundedToDate")) ? 0 : (decimal)reader["fundedToDate"];
                        repaymentDate = reader["repaymentDate"] != DBNull.Value ? (DateTime?)reader["repaymentDate"] : null;
                        repaymentAmt = reader.IsDBNull(reader.GetOrdinal("repaymentAmt")) ? 0 : (decimal)reader["repaymentAmt"];
                        noteStatus = reader.IsDBNull(reader.GetOrdinal("noteStatus")) ? null : (string)reader["noteStatus"];
                        appID = reader.IsDBNull(reader.GetOrdinal("appID")) ? null : (string)reader["appID"];
                    }
                }
            }  // Automatic disposal of connection

            // Constructing the note details string
            return $"{noteAddress}-{listedDate}-{listedEndDate}-{fundedToDate}-{repaymentDate}-{repaymentAmt}-{noteStatus}-{appID}";
        }

        public string GetAppDetails(string appID)
        {
            DateTime? appDateTime = null;
            decimal financingAmt = 0;
            int Duration = 0;
            string financingPurpose = null;
            string creditRating = null;
            decimal interestRate = 0;
            string adminID = null;
            string borrowerID = null;
            string bankStmt = null;
            string Liability = null;
            string mgtAcc = null;
            string status = null;
            DateTime? approvalDate = null;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "SELECT * FROM financingApplication WHERE appID = @appID"; // Adjust your table and column names as necessary
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@appID", appID);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Read each field from the database and convert/store them in variables
                        appDateTime = reader["appDateTime"] != DBNull.Value ? (DateTime?)reader["appDateTime"] : null;
                        financingAmt = reader.IsDBNull(reader.GetOrdinal("financingAmt")) ? 0 : (decimal)reader["financingAmt"];
                        Duration = reader.IsDBNull(reader.GetOrdinal("Duration")) ? 0 : (int)reader["Duration"];
                        financingPurpose = reader.IsDBNull(reader.GetOrdinal("financingPurpose")) ? null : (string)reader["financingPurpose"];
                        creditRating = reader.IsDBNull(reader.GetOrdinal("creditRating")) ? null : (string)reader["creditRating"];
                        interestRate = reader.IsDBNull(reader.GetOrdinal("interestRate")) ? 0 : (decimal)reader["interestRate"];
                        adminID = reader.IsDBNull(reader.GetOrdinal("adminID")) ? null : (string)reader["adminID"];
                        borrowerID = reader.IsDBNull(reader.GetOrdinal("borrowerID")) ? null : (string)reader["borrowerID"];

                        Dictionary<string, object> parameters = new Dictionary<string, object>
                        {
                            { "@appID", appID }
                        };
                        bankStmt = DecryptColumn("financingApplication", "bankStmt", "appID = @appID", parameters);
                        Liability = DecryptColumn("financingApplication", "Liability", "appID = @appID", parameters);
                        mgtAcc = DecryptColumn("financingApplication", "mgtAcc", "appID = @appID", parameters);
                        status = reader.IsDBNull(reader.GetOrdinal("status")) ? null : (string)reader["status"];
                        approvalDate = reader["approvalDate"] != DBNull.Value ? (DateTime?)reader["approvalDate"] : null;
                    }
                }
            }  // Automatic disposal of connection
            return $"{appID}-{appDateTime}-{financingAmt}-{Duration}-{financingPurpose}-{creditRating}-{interestRate}-{adminID}-{borrowerID}-{bankStmt}-{Liability}-{mgtAcc}-{status}-{approvalDate}";
        }

        public string GetClientDetails(string clientID)
        {
            string fullName = null;
            string DoB = null;
            string Gender = null;
            string contactNo = null;
            string publicKey = null;
            string status = null;
            string decryptedIcDoc = null;
            string decryptedIcNo = null;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "SELECT *, CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, icNo)) AS DecryptedIcNo,  CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, icDoc)) AS DecryptedIcDoc FROM Client WHERE clientID = @clientID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
                cmd.Parameters.AddWithValue("@clientID", clientID);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        decryptedIcNo = reader["DecryptedIcNo"] != DBNull.Value ? reader["DecryptedIcNo"].ToString() : null;
                        fullName = reader.IsDBNull(reader.GetOrdinal("fullName")) ? null : (string)reader["fullName"];
                        DoB = reader.IsDBNull(reader.GetOrdinal("DoB")) ? null : (string)reader["DoB"];
                        Gender = reader.IsDBNull(reader.GetOrdinal("Gender")) ? null : (string)reader["Gender"];
                        contactNo = reader.IsDBNull(reader.GetOrdinal("contactNo")) ? null : (string)reader["contactNo"];
                        decryptedIcDoc = reader["decryptedIcDoc"] != DBNull.Value ? reader["decryptedIcDoc"].ToString() : null;
                        publicKey = reader.IsDBNull(reader.GetOrdinal("publicKey")) ? null : (string)reader["publicKey"];
                        status = reader.IsDBNull(reader.GetOrdinal("status")) ? null : (string)reader["status"];
                    }
                }
            }  // Automatic disposal of connection
            return $"{clientID}-{decryptedIcNo}-{fullName}-{DoB}-{Gender}-{contactNo}-{decryptedIcDoc}-{publicKey}-{status}";
        }

        public string GetBorrowerDetails(string borrowerID)
        {
            string bizName = null;
            string bizRegNo = null;
            string bizAdd = null;
            string bizContact = null;
            string bizIndustry = null;
            string entityType = null;
            string bizCert = null;
            string utilityBill = null;
            string form9 = null;
            string bankStmt = null;
            string clientID = null;
            string decryptedbizCert = null;
            string decryptedutilityBill = null;
            string decryptedform9 = null;
            string decryptedbankStmt = null;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "SELECT *, CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, bizCert)) AS DecryptedbizCert, " +
                    "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, utilityBill)) AS DecryptedutilityBill, " +
                    "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, form9)) AS Decryptedform9, " +
                    "CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, bankStmt)) AS DecryptedbankStmt " +
                    "FROM Borrower WHERE borrowerID = @borrowerID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Passphrase", "FYPp2plendingsystem23!");
                cmd.Parameters.AddWithValue("@borrowerID", borrowerID);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Read each field from the database and convert/store them in variables
                        bizName = reader.IsDBNull(reader.GetOrdinal("bizName")) ? null : (string)reader["bizName"];
                        bizRegNo = reader.IsDBNull(reader.GetOrdinal("bizRegNo")) ? null : (string)reader["bizRegNo"];
                        bizAdd = reader.IsDBNull(reader.GetOrdinal("bizAdd")) ? null : (string)reader["bizAdd"];
                        bizContact = reader.IsDBNull(reader.GetOrdinal("bizContact")) ? null : (string)reader["bizContact"];
                        bizIndustry = reader.IsDBNull(reader.GetOrdinal("bizIndustry")) ? null : (string)reader["bizIndustry"];
                        entityType = reader.IsDBNull(reader.GetOrdinal("entityType")) ? null : (string)reader["entityType"];
                        decryptedbizCert = reader["DecryptedbizCert"] != DBNull.Value ? reader["DecryptedbizCert"].ToString() : null;
                        decryptedutilityBill = reader["DecryptedutilityBill"] != DBNull.Value ? reader["DecryptedutilityBill"].ToString() : null;
                        decryptedform9 = reader["Decryptedform9"] != DBNull.Value ? reader["Decryptedform9"].ToString() : null;
                        decryptedbankStmt = reader["DecryptedbankStmt"] != DBNull.Value ? reader["DecryptedbankStmt"].ToString() : null;
                        clientID = reader.IsDBNull(reader.GetOrdinal("clientID")) ? null : (string)reader["clientID"];
                    }

                    Debug.WriteLine(bizCert);
                    Debug.WriteLine(bizRegNo);
                    Debug.WriteLine(form9);
                    Debug.WriteLine(bankStmt);
                }
            }  // Automatic disposal of connection
            return $"{borrowerID}-{bizName}-{bizRegNo}-{bizAdd}-{bizContact}-{bizIndustry}-{entityType}-{decryptedbizCert}-{decryptedutilityBill}-{decryptedform9}-{decryptedbankStmt}-{clientID}";
        }

        public string GetLenderDetails(string lenderID)
        {
            // Initialization of variables
            string annualIncome = null;
            string riskTolerance = null;
            string riskAck = null;
            string clientID = null;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                con.Open();
                string query = "SELECT * FROM Lender WHERE lenderID = @lenderID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@lenderID", lenderID);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        annualIncome = reader.IsDBNull(reader.GetOrdinal("annualIncome")) ? null : (string)reader["annualIncome"];
                        riskTolerance = reader.IsDBNull(reader.GetOrdinal("riskTolerance")) ? null : (string)reader["riskTolerance"];
                        riskAck = reader.IsDBNull(reader.GetOrdinal("riskAck")) ? null : (string)reader["riskAck"];
                        clientID = reader.IsDBNull(reader.GetOrdinal("clientID")) ? null : (string)reader["clientID"];
                    }
                }
            }  // Automatic disposal of connection
            return $"{lenderID}-{annualIncome}-{riskTolerance}-{riskAck}-{clientID}";
        }

        public static void EncryptColumn(string tableName, string columnName, string condition, Dictionary<string, object> parameters)
        {
            string query = $@"UPDATE {tableName}
                      SET {columnName} = ENCRYPTBYPASSPHRASE(@Passphrase, CAST({columnName} AS nvarchar(max))) 
                      {condition};";

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@Passphrase", passphrase);

                // Add additional parameters for the condition
                foreach (var param in parameters)
                {
                    command.Parameters.AddWithValue(param.Key, param.Value);
                }

                con.Open();
                command.ExecuteNonQuery();
            }
        }

        public static void EncryptColumn(string tableName, string columnName, string condition)
        {
            string query = $@"UPDATE {tableName}
                          SET {columnName} = ENCRYPTBYPASSPHRASE(@Passphrase, {columnName})
                          {condition};";

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@Passphrase", passphrase);
                con.Open();
                command.ExecuteNonQuery();
            }
        }

        public static string DecryptColumn(string tableName, string columnName, string condition, Dictionary<string, object> parameters)
        {
            string query = $@"SELECT CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE(@Passphrase, {columnName}))
                      AS DecryptedColumn FROM {tableName} WHERE {condition};";

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@Passphrase", passphrase); // Your passphrase for decryption

                // Add additional parameters from the dictionary
                foreach (var param in parameters)
                {
                    command.Parameters.AddWithValue(param.Key, param.Value);
                }

                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Check if the result is DBNULL or an empty string
                        if (reader["DecryptedColumn"] != DBNull.Value)
                        {
                            string decryptedValue = reader["DecryptedColumn"].ToString();
                            // Further check if the decrypted value is not empty
                            if (!string.IsNullOrEmpty(decryptedValue))
                            {
                                Debug.WriteLine("hi deecrypted value: " + decryptedValue);
                                return decryptedValue;
                            }
                        }
                    }
                    return null;
                }
            }
        }

        /*public static string DecryptColumn(string tableName, string columnName, string condition)
        {
            string query = $@"SELECT CONVERT(nvarchar(50), DECRYPTBYPASSPHRASE(@Passphrase, {columnName}))
                      AS DecryptedColumn FROM {tableName} WHERE {condition};";

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                SqlCommand command = new SqlCommand(query, con);
                command.Parameters.AddWithValue("@Passphrase", passphrase); // Your passphrase for decryption

                con.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Check if the result is DBNULL or an empty string
                        if (reader["DecryptedColumn"] != DBNull.Value)
                        {
                            string decryptedValue = reader["DecryptedColumn"].ToString();
                            // Further check if the decrypted value is not empty
                            if (!string.IsNullOrEmpty(decryptedValue))
                            {
                                return decryptedValue;
                            }
                        }
                    }
                    // Return a specific indicator or handle the case for non-encrypted or empty data
                    return null; // Or handle as needed, possibly throw an exception or return null
                }
            }
        }*/

    }
}