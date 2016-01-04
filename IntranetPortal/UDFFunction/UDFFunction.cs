using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using Newtonsoft.Json.Linq;
using DuoVia.FuzzyStrings;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString UDFFunction()
    {
        // Put your code here
        return new SqlString (string.Empty);
    }
    [SqlFunction]
    public static bool Like(string text, string pattern)
    {
        if (String.IsNullOrEmpty(text))
        {
            return false;
        }
        Match match = Regex.Match(text.Trim(), pattern);
        return (match.Value != String.Empty);
    }
    [SqlFunction]
    public static string ParseJson(string text, string token)
    {
        if (String.IsNullOrEmpty(text))
        {
            return null;
        }

        if (String.IsNullOrEmpty(token))
        {
            return "select token can not be null";
        }
        JObject json = JObject.Parse(text);
        if (json == null)
        {
            return "Can not parse to json";
        }
        JToken vJtoken = json.SelectToken(token);
        if (vJtoken == null)
        {
            return null;
        }
        return vJtoken.ToString();
    }

    [SqlFunction]
    public static double FuzzyMatch(string text1, string text2)
    {
        if (String.IsNullOrEmpty(text1) || String.IsNullOrEmpty(text2))
        {
            return 0;
        }
        Regex rgx = new Regex("[^a-zA-Z -]");
        text1 = rgx.Replace(text1,"").Trim();
        text2 = rgx.Replace(text2,"").Trim();
        return text1.FuzzyMatch(text2);

    }
}
