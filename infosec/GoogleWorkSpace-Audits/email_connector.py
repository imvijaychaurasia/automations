import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication

# SMTP credentials and configuration
sender_email = "abcd@xyz.com" ##update the senders email id
receiver_email = "efgh@xyz.com" ##update the receviers email id
password = "password" ##update the password
smtp_server = "smtp.gmail.com" ##example google smtp, change the smtp based on your server
smtp_port = 587 ##change the smtp port

def send_email_with_attachment(subject, body, attachment_path, inline_images):
    # Create email message with HTML content
    msg = MIMEMultipart('related')
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    # Attach inline images with specified Content-ID for each image
    for image_path, cid in inline_images:
        with open(image_path, 'rb') as img_file:
            img = MIMEImage(img_file.read())
            img.add_header('Content-ID', f'<{cid}>')
            img.add_header('Content-Disposition', 'inline', filename=image_path)
            msg.attach(img)

    # Attach the CSV file
    with open(attachment_path, 'rb') as f:
        attachment = MIMEApplication(f.read(), _subtype='csv')
        attachment.add_header('Content-Disposition', 'attachment', filename='external_sharing_report_all_files.csv')
        msg.attach(attachment)

    # Send the email
    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, msg.as_string())
        print("Email sent successfully!")
    except Exception as e:
        print(f"Error sending email: {e}")
