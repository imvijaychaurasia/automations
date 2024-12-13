import pandas as pd
import matplotlib.pyplot as plt
import io
import json
import subprocess

# Load and preprocess CSV Data
def load_data(filepath):
    df = pd.read_csv(filepath)
    
    # Extract domain from "Recipient" as "External_Domains"
    df['External_Domains'] = df['Recipient'].str.extract(r'@([a-zA-Z0-9.-]+)')
    
    # Remove duplicates based on "File_ID"
    df = df.drop_duplicates(subset='File_ID')
    
    return df

# Generate summary statistics
def calculate_summary_stats(df):
    total_shared_files = len(df)
    unique_shared_files = df['File_ID'].nunique()
    total_external_recipients = df['Recipient'].nunique()

    # Filter file owners for top 10 internal owners (containing xyz or abc)
    internal_owners = df[df['File_Owner'].str.contains('@xyz|@bzlnks', case=False, na=False)]
    top_10_file_owners = internal_owners['File_Owner'].value_counts().head(10)
    
    # File type counts
    file_type_counts = df['File_Type'].value_counts()

    return {
        "total_shared_files": total_shared_files,
        "unique_shared_files": unique_shared_files,
        "total_external_recipients": total_external_recipients,
        "top_10_file_owners": top_10_file_owners.to_dict(),
        "file_type_counts": file_type_counts.to_dict()
    }

# Generate pivot tables and plots
def generate_pivots_and_charts(df):
    image_files = {}

    # Generate and save each chart to bytes
    def save_chart_to_bytes(plot_data, title, xlabel, ylabel, color):
        plt.figure(figsize=(10, 6))
        plot_data.plot(kind='bar', color=color)
        plt.title(title)
        plt.xlabel(xlabel)
        plt.ylabel(ylabel)
        plt.tight_layout()
        buffer = io.BytesIO()
        plt.savefig(buffer, format='png')
        buffer.seek(0)
        plt.close()
        return buffer.getvalue()

    image_files['external_domain_distribution'] = save_chart_to_bytes(
        df['External_Domains'].value_counts().sort_values(ascending=False),
        'Externally Shared Files by Domain',
        'External Domain', 'Count', 'purple'
    )

    image_files['file_owner_distribution'] = save_chart_to_bytes(
        df['File_Owner'].value_counts().sort_values(ascending=False),
        'Externally Shared Files by File Owner',
        'File Owner', 'Count', 'orange'
    )

    image_files['file_type_distribution'] = save_chart_to_bytes(
        df['File_Type'].value_counts().sort_values(ascending=False),
        'Externally Shared Files by File Type',
        'File Type', 'Count', 'blue'
    )

    image_files['top_recipients'] = save_chart_to_bytes(
        df['Recipient'].value_counts().sort_values(ascending=False).head(10),
        'Top 10 Recipients of Shared Files',
        'Recipient Email', 'Count of Shared Files', 'green'
    )

    return image_files

import subprocess

# At the end of main function, add:
def main():
    filepath = "external_sharing_report_all_files.csv"
    data = load_data(filepath)
    summary_stats = calculate_summary_stats(data)
    report_images = generate_pivots_and_charts(data)

    # Save summary stats and images for email
    with open('summary_stats.json', 'w') as f:
        json.dump(summary_stats, f)
    for name, image in report_images.items():
        with open(f'{name}.png', 'wb') as img_file:
            img_file.write(image)
    
    # Trigger the email script
    try:
        subprocess.run(['python3', 'analysis_email.py'], check=True)
        print("Email analysis script triggered successfully.")
    except Exception as e:
        print(f"Error triggering email analysis: {e}")

if __name__ == "__main__":
    main()
