import streamlit as st
import pandas as pd
import plotly.express as px
import os
import numpy as np
from pathlib import Path


#Page configuration
st.set_page_config(page_title="Data Intelligence", layout="wide")

# Get script directory
script_dir = Path(__file__).parent.absolute()
os.chdir(script_dir)

#Load CSS
with open('style.css') as f:
      st.markdown(f"<style>{f.read()}</style>", unsafe_allow_html=True)

os.makedirs('../data/analytics/customer_metrics', exist_ok=True)

#Load data
customer_metrics=pd.read_csv('../data/analytics/customer_metrics/customer_metrics.csv')
customer_value_metrics=pd.read_csv('../data/analytics/customer_metrics/customer_value_metrics.csv')
top_customer_metrics=pd.read_csv('../data/analytics/customer_metrics/top_customer_metrics.csv')

heatmap_booking_data=pd.read_csv('../data/analytics/heatmap/heatmap_booking_data.csv')
heatmap_revenue=pd.read_csv('../data/analytics/heatmap/heatmap_revenue.csv')

completion_rate=pd.read_csv('../data/analytics/KPIs/completion_rate.csv')
service_performance=pd.read_csv('../data/analytics/KPIs/service_performance.csv')

daily_revenue=pd.read_csv('../data/analytics/revenue_datasets/daily_revenue.csv')
monthly_revenue=pd.read_csv('../data/analytics/revenue_datasets/monthly_revenue.csv')
weekly_revenue=pd.read_csv('../data/analytics/revenue_datasets/weekly_revenue.csv')
revenue_insights=pd.read_csv('../data/analytics/revenue_datasets/revenue_insights.csv')
revenue_summary=pd.read_csv('../data/analytics/revenue_datasets/revenue_summary.csv')

delay_statistics=pd.read_csv('../data/analytics/time_analysis/delay_statistics.csv')
late_customers=pd.read_csv('../data/analytics/time_analysis/late_customer.csv')

service_performance['service_id']=[1,2,3]


# Title
st.markdown('<h1 class="main-header">ANALYTICS DASHBOARD</h1>', unsafe_allow_html=True)

#Row 1: Customer Intelligence (grouped together)
# print(customer_metrics)
# print(customer_value_metrics)
# print(top_customer_metrics)

st.markdown('<div class="customer-value-header-1">Customer Intelligence</div>', unsafe_allow_html=True)

intel_cols=st.columns(4)

with intel_cols[0]:
    st.markdown(f"""
    <div class="customer-intel-card">
        <div class="intel-label">Total Customers</div>
        <div class="intel-value">{int(customer_metrics['total_customers'][0])}</div>
    </div>
    """, unsafe_allow_html=True)

with intel_cols[1]:
    st.markdown(f"""
    <div class="customer-intel-card">
        <div class="intel-label">Repeat Rate</div>
        <div class="intel-value">{customer_metrics['repeat_rate'][0]:.1f}%</div>
    </div>
    """, unsafe_allow_html=True)

with intel_cols[2]:
    st.markdown(f"""
    <div class="customer-intel-card">
        <div class="intel-label">Best Customer ID</div>
        <div class="intel-value">{int(top_customer_metrics['best_customer'][0])}</div>
    </div>
    """, unsafe_allow_html=True)

with intel_cols[3]:
    st.markdown(f"""
    <div class="customer-intel-card">
        <div class="intel-label">Avg Customer Lifetime Value</div>
        <div class="intel-value">R{top_customer_metrics['average_customer_value'][0]:.2f}</div>
    </div>
    """, unsafe_allow_html=True)

# Create main layout with two columns
left_col, right_col = st.columns([1.2, 1.8])

with left_col:
    st.markdown('<div class="customer-value-header-1">Customer Value Metrics</div>', unsafe_allow_html=True)

    # Scrollable Customer Value Metrics Table
    #format the dataframe for display
    customer_value_metrics['total_amount_paid']=customer_value_metrics['total_amount_paid'].apply(lambda x: f"R{x:.2f}")
    # Convert to HTML table for scrollable effect
    table_html = customer_value_metrics.to_html(index=False, classes='customer-table', escape=False)

    # st.markdown(table_html, unsafe_allow_html=True)
    # st.markdown('</div>', unsafe_allow_html=True)

    # Wrap in your container with the scrollable class
    st.markdown(f"""
    <div class="scrollable-table-container">
        <div class="table-header">
            <span class="kpi-label">CUSTOMER VALUE METRICS</span>
            <span class="scroll-hint" style="color: #999; font-size: 11px;">↓ Scroll for more</span>
        </div>
        {table_html}
    </div>
    """, unsafe_allow_html=True)

    # Add a download button for the customer data
    # col_d1, col_d2, col_d3 = st.columns([1, 2, 1])
    # with col_d2:
    #     if st.button("EXPORT TO CSV", use_container_width=True):
    #         # Use the original numeric DataFrame for export, not the formatted display_df
    #         export_df = customer_value_metrics.copy()
    #         export_df.columns = ['customer_id', 'total_amount_paid']  # Keep numeric values
    #         csv = export_df.to_csv(index=False).encode('utf-8')
            
    #         st.download_button(
    #             label="CLICK TO DOWNLOAD",
    #             data=csv,
    #             file_name="customer_value_metrics.csv",
    #             mime="text/csv",
    #             use_container_width=True
    #         )


print(customer_value_metrics.head())
with right_col:
    # Right column content (for additional analytics)
    st.markdown('<div class="customer-value-header-1">Customer Value Insights</div>', unsafe_allow_html=True)


    # Create container for the histogram that aligns with table
    

    # Create two compact visualizations that fit side by side
    viz_col1, viz_col2 = st.columns([1.2, 1])

    with viz_col1:
        st.markdown('<div class="kpi-label">Lifetime Value Distribution</div>', unsafe_allow_html=True)
        
        # Customer Lifetime Value Distribution Histogram
        value_data = customer_value_metrics['total_amount_paid'].astype(str).str.replace('R', '').str.replace(',', '').astype(float)

        import matplotlib.pyplot as plt
        from matplotlib.patches import BoxStyle, FancyBboxPatch
        import matplotlib.cm as cm
        
        fig, ax = plt.subplots(figsize=(5, 4.5))
        # Better bin calculation
        bins = np.histogram_bin_edges(value_data, bins="fd")

        n, bins, patches = ax.hist(value_data, 
                          bins=bins, 
                          edgecolor="#000000", 
                        #   color="#f48610",
                          alpha=0.8)
        
        # Apply premium gold gradient
        for i, patch in enumerate(patches):
            
            intensity = i / (len(patches) - 1)
            
            patch.set_facecolor((
                0.60 + intensity * 0.40,   # R: 0.60 → 1.00
                0.10 + intensity * 0.65,   # G: 0.10 → 0.75
                0.05 + intensity * 0.15    # B: 0.05 → 0.20
            ))
        # colors = cm.plasma(np.linspace(0.2, 0.9, len(patches)))

        # for patch, color in zip(patches, colors):
        #     patch.set_facecolor(color)
            # Statistics
        mean_val = np.mean(value_data)

        # Mean line
        ax.axvline(
            mean_val,
            color="#ff9900",
            linestyle="--",
            linewidth=0.8,
            alpha=0.7,
            label=f"Mean: R{mean_val:.0f}"
        )
        
        # Highlight high-value zone
        ax.axvspan(
            600,
            value_data.max(),
            color="#e6c27a",
            alpha=0.08
        )

        #styling
        # ax.set_title('Customer Lifetime Value Distribution', fontsize=14, fontweight='bold', color='#e6c27a', pad=15)
        ax.set_xlabel('Payment Amount (R)', fontsize=11, color='#999')
        ax.set_ylabel('Number of Customers', fontsize=11, color='#999')
        
        # Premium styling
        ax.set_facecolor("#000000")
        fig.patch.set_facecolor("#000000")

       
        ax.tick_params(colors='#999', labelsize=9)
        ax.grid(True, alpha=0.15, color='#e6c27a', linestyle='--', linewidth=0.5, axis='y')

        # Style spines
        for spine in ax.spines.values():
            spine.set_color('#333')
            spine.set_linewidth(1)
        
        # Legend
        leg = ax.legend(frameon=False)
        for text in leg.get_texts():
            text.set_color("#aaa")

        plt.tight_layout()

        st.pyplot(fig, use_container_width=True)
        plt.close()
        st.markdown("""
            </div>
        </div>
        """, unsafe_allow_html=True)
    # First, create a numeric version of your data for calculations
    numeric_data = customer_value_metrics.copy()
    # Remove 'R' and convert to float if needed
    if numeric_data['total_amount_paid'].dtype == 'object':
        numeric_data['total_amount_paid'] = numeric_data['total_amount_paid'].astype(str).str.replace('R', '').astype(float)
        
    with viz_col2:
        
        st.markdown('<div class="kpi-label">Cumulative Revenue (Pareto)</div>', unsafe_allow_html=True)
        
        # Sort customers by value descending
        sorted_data = numeric_data.sort_values('total_amount_paid', ascending=False).reset_index(drop=True)
        sorted_data['cumulative_percent'] = (sorted_data['total_amount_paid'].cumsum() / 
                                            sorted_data['total_amount_paid'].sum() * 100)
        sorted_data['customer_percent'] = (sorted_data.index + 1) / len(sorted_data) * 100
        
        fig, ax = plt.subplots(figsize=(5, 5.4))
        
        # Plot cumulative line
        ax.plot(sorted_data['customer_percent'], sorted_data['cumulative_percent'], 
                color="#ea7114", linewidth=1.5)
        
        # Add 80/20 lines
        ax.axhline(y=80, color='#e6c27a', linestyle='--', alpha=0.3, linewidth=1.1)
        ax.axvline(x=20, color='#e6c27a', linestyle='--', alpha=0.3, linewidth=1.1)
        
        # Fill area under curve
        ax.fill_between(sorted_data['customer_percent'], sorted_data['cumulative_percent'], 
                        alpha=0.1, color="#ea7114")
        
        ax.set_xlabel('Customers (%)', color='#999')
        ax.set_ylabel('Revenue (%)', color='#999')
        ax.set_facecolor("#000000")
        fig.patch.set_facecolor("#000000")
        ax.tick_params(colors='#999')
        ax.grid(True, alpha=0.15, color='#e6c27a', linestyle='--', axis='y')
        
        # Add annotation
        top_20_pct = int(len(sorted_data) * 0.2)
        revenue_from_top20 = sorted_data.head(top_20_pct)['total_amount_paid'].sum()
        total_revenue = sorted_data['total_amount_paid'].sum()
        top20_percentage = (revenue_from_top20 / total_revenue) * 100
        
        ax.text(50, 30, f'Top 20% generate\n{top20_percentage:.1f}% of revenue',
                ha='center', fontsize=10,
                bbox=dict(boxstyle='round', facecolor='#111111', 
                        edgecolor='#e6c27a', alpha=0.8),
                color='#e6c27a')
        
        plt.tight_layout()
        st.pyplot(fig, use_container_width=True)
        plt.close()
        st.markdown('</div>', unsafe_allow_html=True)

left_col1, right_col2 = st.columns([1.2, 1.8])
#structural1 columns


with left_col1:
     
    row1 = st.container()
    with row1:

        service_cols=st.columns(2)
        with service_cols[0]:
            st.markdown(f"""
            <div class="booking-completion-card">
                <div class="booking-completion-header">Booking Completion Rate</div>
                <div class="booking-value">{completion_rate['booking_completion_rate'].iloc[0]:.1f}%</div>
                <div class="booking-completion-status">significantly low</div>
            </div>
            </div>
            """, unsafe_allow_html=True)
        with service_cols[1]:
            st.markdown(f"""
            <div class="customer-intel-card">
                <div class="kpi-label">Service {int(service_performance['service_id'].iloc[0])}</div>
                <div class="kpi-value">R{service_performance['service_revenue'].iloc[0]:,.0f}</div>
                <div class="service-bookings">{int(service_performance['service_count'].iloc[0])} bookings</div>
            </div>
            """, unsafe_allow_html=True)
    

    row2 = st.container()
    with row2:
        
        service_cols=st.columns(2)
        with service_cols[0]:
           st.markdown(f"""
            <div class="customer-intel-card">
                <div class="kpi-label">Service {int(service_performance['service_id'].iloc[1])}</div>
                <div class="kpi-value">R{service_performance['service_revenue'].iloc[1]:,.0f}</div>
                <div class="service-bookings">{int(service_performance['service_count'].iloc[1])} bookings</div>
            </div>
            """, unsafe_allow_html=True) 
        
        with service_cols[1]:
            st.markdown(f"""
            <div class="customer-intel-card">
                <div class="kpi-label">Service {int(service_performance['service_id'].iloc[2])}</div>
                <div class="kpi-value">R{service_performance['service_revenue'].iloc[2]:,.0f}</div>
                <div class="service-bookings">{int(service_performance['service_count'].iloc[2])} bookings</div>
            </div>
            """, unsafe_allow_html=True)

with right_col2:
    cols=st.columns([ 2,1])
    with cols[0]:

        import matplotlib.pyplot as plt
        struct_row1=st.container()
        
        # with struct_row1:
        plt.subplots(figsize=(6.5, 3.5))
        plt.plot(daily_revenue.index, daily_revenue.values, 
            color="#e0dac6",  # Changed to orange-red to match theme 
            markersize=4,
            linewidth=1,
            alpha=0.4,
            label='Daily Average Trend',
            )
        
        #Add a 7-day moving average (optional enhancement)
        ma_7 = daily_revenue['payment_amount'].rolling(window=7, min_periods=1).mean()
        plt.plot(daily_revenue.index, ma_7, 
                color="#ea7114",  # Gold
                linewidth=0.7, 
                
                alpha=0.7,
                label='7-Day Average')
        # Fill area under curve
        plt.fill_between(daily_revenue.index, ma_7, 
                    color="#f4c971", 
                    alpha=0.055)
        #styling
        # plt.title('Daily Revenue Trend', fontsize=14, fontweight='bold', color='#e6c27a', pad=15)

        plt.xlabel('Date',color='#999')


        # Add legend
        plt.legend(facecolor="#000000", edgecolor='#333', labelcolor='#e6c27a', fontsize=10)
        # Style the chart
        ax = plt.gca()
        ax.set_facecolor("#000000")
        plt.gcf().patch.set_facecolor("#000000")
        ax.tick_params(colors='#999', labelsize=9)
        ax.grid(True, alpha=0.15, color="#ffffff", linestyle='-', linewidth=0.5, axis='y')

        # Style spines
        # for spine in ax.spines.values():
        #     spine.set_color('#333')
        #     spine.set_linewidth(1)

        
        plt.tight_layout()
        st.pyplot(plt.gcf())
        plt.close()
        
        st.markdown("""
            </div>
        </div>
        """, unsafe_allow_html=True)
    print(customer_value_metrics.head())
    customer_value_metrics['total_amount_paid'] = customer_value_metrics['total_amount_paid'].str.replace('R', '').astype(float).astype(int)
    print(customer_value_metrics.head())
    with cols[1]:
        import matplotlib.patches as mpatches
        from matplotlib.patches import Circle, Wedge
        from matplotlib.colors import LinearSegmentedColormap
         
        conditions = [
            (customer_value_metrics['total_amount_paid'] < 250),
            (customer_value_metrics['total_amount_paid'] >= 250) & (customer_value_metrics['total_amount_paid'] < 400),
            (customer_value_metrics['total_amount_paid'] >= 400) & (customer_value_metrics['total_amount_paid'] < 600),
            (customer_value_metrics['total_amount_paid'] >= 600)
        ]
        labels = ['Low ', 'Medium','High','VIP' ]
        customer_value_metrics['segment'] = np.select(conditions, labels)     
        print(customer_value_metrics.head())
        segment_counts = customer_value_metrics['segment'].value_counts().reindex(labels, fill_value=0)


    #     st.markdown('<div style="margin-bottom: -40px;">', unsafe_allow_html=True)
        
        fig, ax = plt.subplots(figsize=(6,6))
        fig.patch.set_facecolor("#000000")
        ax.set_facecolor("#000000")

        # Professional color palette (Pisocore gold theme)
        # colors = ["#e76b0c", "#DF7116", "#EC8816", "#FFBB00"]
        colors = [
            '#FF6B00',   # Low - strong orange
            '#FFA500',   # Medium - bright amber
            '#FFD700',   # High - gold
            "#02E1F9"    # VIP - electric cyan (stands out)
        ]

        
    
        # Outer glow ring (depth effect)
        ax.pie(
            [1],
            radius=1.25,
            colors=['#1C2333'],
            wedgeprops=dict(width=0.10, edgecolor='none',alpha=0.6)
        )
        # Main segmentation ring
        wedges, texts, autotexts = ax.pie(
            segment_counts,
            radius=1,
            labels=segment_counts.index,
            colors=colors,
            autopct='%1.0f%%',
            pctdistance=0.8,
            labeldistance=1.05,
            startangle=90,
            wedgeprops=dict(width=0.35, edgecolor='#0E1117')
        )   
        # Center text (executive KPI)
        total_customers = segment_counts.sum()

        ax.text(0, 0.05, f"{total_customers}",
                ha='center', va='center',
                fontsize=28, fontweight='bold',
                color='white')

        ax.text(0, -0.15, "Customers",
                ha='center', va='center',
                fontsize=12,
                color='gray')

        ax.set(aspect="equal")
        ax.set_title("CUSTOMER SEGMENTATION",
                    color='white',
                    fontsize=14,
                    pad=20)
        plt.setp(texts, color='white')
        plt.setp(autotexts, color='black', fontweight='bold')

        st.pyplot(fig)

# import seaborn as sns
# import matplotlib.pyplot as plt
# from matplotlib.colors import LinearSegmentedColormap

# fig, ax = plt.subplots(figsize=(14, 5))

# colors = ['#8B0000', '#B22222', '#DC143C', '#FF4500', '#FF8C00', '#FFA500', '#FFB347', '#FFD700']
# custom_cmap = LinearSegmentedColormap.from_list('custom_red_orange', colors, N=256)

# # Dark background styling
# fig.patch.set_facecolor("#000000")
# ax.set_facecolor("#000000")
# plt.gcf().patch.set_facecolor("#000000")
# sns.heatmap(
#     heatmap_booking_data,
#     cmap="OrRd",  # Orange-Red gradient
#     fmt='d', 
#     # cmap=custom_cmap,
#     linewidths=0.2,
#     linecolor='#2F2F2F',
#     annot_kws={'size': 10, 'weight': 'bold'},
#                 cbar_kws={'label': 'Number of Bookings', 
#                          'orientation': 'vertical',
#                          'shrink': 0.8,
#                          'pad': 0.02},ax=ax)



# # ax.set_title("Booking Distribution by Day & Hour",
# #              color='white',
# #              fontsize=14,
# #              pad=15)

# plt.xlabel('Hour of Day (24h format)', fontsize=12, fontweight='semibold', labelpad=10)
# plt.ylabel('Day of Week', fontsize=12, fontweight='semibold', labelpad=10)

# # Customize tick labels
# plt.xticks(fontsize=11, rotation=0)
# plt.yticks(fontsize=11, rotation=0)

# ax.tick_params(colors='black')
# # Add peak hours annotation (optional - find max booking time)
# max_day_hour = heatmap_booking_data.stack().idxmax()
# max_value = heatmap_booking_data.stack().max()
# plt.text(0.02, 0.98, f'Peak: {max_day_hour[0]} @ {max_day_hour[1]}:00 ({max_value} bookings)', 
#          transform=ax.transAxes,
#          fontsize=10,
#          verticalalignment='top',
#          bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

# plt.tight_layout()
# plt.show()
# plt.tight_layout()

# st.pyplot(fig)

    
























