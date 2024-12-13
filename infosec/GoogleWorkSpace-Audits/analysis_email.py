import json
from email_connector import send_email_with_attachment

def prepare_email_content():
    # Load summary statistics
    with open('summary_stats.json') as f:
        summary_stats = json.load(f)

    # HTML email content with embedded charts and responsive styling
    body = f"""
    <html>
    <head>
        <style>
            /* General styling */
            body {{
                font-family: Arial, sans-serif;
                color: #333;
                margin: 0;
                padding: 0;
            }}
            .content {{
                width: 90%;
                max-width: 600px;
                margin: auto;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }}
            h2 {{
                color: #4CAF50;
                font-size: 24px;
                text-align: center;
            }}
            h3 {{
                color: #333;
                font-size: 20px;
                margin-top: 24px;
            }}
            .intro {{
                text-align: left;
                font-size: 16px;
                margin-bottom: 20px;
            }}
            .stats {{
                display: flex;
                justify-content: space-around;
                margin-bottom: 20px;
                text-align: center;
            }}
            .stat-box {{
                background-color: #ffffff;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                width: 45%;
            }}
            .stat-value {{
                font-size: 24px;
                font-weight: bold;
                color: #4CAF50;
            }}
            .stat-label {{
                font-size: 16px;
                color: #666;
            }}
            .chart {{
                margin: 20px auto;
                width: 100%;
                max-width: 400px;
                display: block;
            }}
            @media only screen and (max-width: 600px) {{
                .stats {{
                    flex-direction: column;
                    align-items: center;
                }}
                .stat-box {{
                    width: 80%;
                    margin-bottom: 15px;
                }}
            }}
        </style>
    </head>
    <body>
        <div class="content">
            <h2>📈 Summary on files shared outside Domains</h2>
            
            <p class="intro">Hello Team,<br>Sharing with you all today's report which provides a detailed overview of external file sharing activity in our Google Workspace.<br>This report is fully automated, from data extraction using GW APIs, to running analysis on extracted report, and sending this email. The raw extracted report is also attached with this email for your reference.</br></p>
            
            <!-- Total Unique Records and Total External Recipients -->
            <div class="stats">
                <div class="stat-box">
                    <div class="stat-value">{summary_stats['total_shared_files']}</div>
                    <div class="stat-label">Total Unique Records</div>
                </div>
                <div class="stat-box">
                    <div class="stat-value">{summary_stats['total_external_recipients']}</div>
                    <div class="stat-label">Total External Recipients</div>
                </div>
            </div>

            <h3>External Domains</h3>
            <img class="chart" src="cid:external_domain_distribution" alt="External Domains">

            <h3>File Owners</h3>
            <img class="chart" src="cid:file_owner_distribution" alt="File Owner Distribution">

            <h3>File Types distribution</h3>
            <img class="chart" src="cid:file_type_distribution" alt="File Types Distribution">

            <h3>Top10 Recipients by total records</h3>
            <img class="chart" src="cid:top_recipients" alt="Top Recipients">
        </div>
    </body>
    </html>
    """
    
    return body

if __name__ == "__main__":
    email_subject = "📊 Automated: Google WorkSpace - External Sharing Report"
    email_body = prepare_email_content()
    attachment_path = "/path/to/file/external_sharing_report_all_files.csv" ##change the path where the reported file is stored
    inline_images = [
        ('external_domain_distribution.png', 'external_domain_distribution'),
        ('file_owner_distribution.png', 'file_owner_distribution'),
        ('file_type_distribution.png', 'file_type_distribution'),
        ('top_recipients.png', 'top_recipients')
    ]
    
    send_email_with_attachment(email_subject, email_body, attachment_path, inline_images)
