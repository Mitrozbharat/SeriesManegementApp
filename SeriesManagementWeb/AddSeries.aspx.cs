using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SeriesManagementWeb
{
    public partial class AddSeries : System.Web.UI.Page
    {
        protected string PageMode = "A"; // Default to Add

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var modeParam = Request.QueryString["Mode"];
                if (!string.IsNullOrEmpty(modeParam))
                {
                    try
                    {
                        PageMode = Encoding.UTF8.GetString(Convert.FromBase64String(modeParam));
                    }
                    catch
                    {
                        PageMode = "A";
                    }
                }

                if (PageMode == "A")
                {
                    // ADD MODE: Clear fields, set button text, etc.
                }
                else if (PageMode == "E")
                {
                    // UPDATE MODE: Load series data, set button text, etc.
                }
            }
        }
    }

      
}