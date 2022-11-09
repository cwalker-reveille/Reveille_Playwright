<%@ Page Language="C#" Async="true" Debug="true" AutoEventWireup="true" Inherits="System.Web.UI.Page" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="Microsoft.Playwright" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
</head>
<body>
</body>
<script runat="server" language="c#">
    public void Page_Load( object sender, EventArgs e )
    {
        RegisterAsyncTask( new PageAsyncTask( RunTest ) );
    }
    private async Task RunTest()
    {
        System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
        sw.Start();
        var playwright = await Playwright.CreateAsync();
        try
        {
            var browser = await playwright.Chromium.LaunchAsync( new BrowserTypeLaunchOptions()
            {
                Headless = true,
                Channel = "chrome",

            } );
            var context = await browser.NewContextAsync();

            Response.Clear();

            // Open new page
            var page = await context.NewPageAsync();
            sw.Stop();
            Response.Write( $"Playwrite setup elapsed: {formatElapsed( sw.ElapsedMilliseconds )} s <br/>" );

            sw = System.Diagnostics.Stopwatch.StartNew();
            await page.GotoAsync( "https://reveillesoftware.com/" );
            sw.Stop();
            Response.Write( $"Route to reveillesoftware.com {formatElapsed( sw.ElapsedMilliseconds )} s<br/>" );
            sw = System.Diagnostics.Stopwatch.StartNew();
            await page.Locator( "#top-menu >> text=Company" ).ClickAsync();
            await page.Locator( "#top-menu >> text=About" ).ClickAsync();
            sw.Stop();
            // Should be on the about page
            if ( page.Url == "https://www.reveillesoftware.com/about/" )
            {
                Response.Write( $"Click to 'about' page {formatElapsed( sw.ElapsedMilliseconds )} s<br/>" );
            }

            Response.Write( "Done" );
        }
        catch ( Exception ex )
        {
            Response.Write( $"Exception thrown: {ex.Message}" );
        }
        finally
        {
            playwright.Dispose();
        }

    }
    private string formatElapsed( long ms )
    {
        decimal s = (decimal)ms / (decimal)1000;
        return String.Format( "{0:0.0##}", s );
    }

</script>
</html>
