import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns

def set_jupyter_env():
    """
    Setup some jupyter notebook related parameters for plots and pandas dataframe displaying.
    """
    # set jupyter notebook pandas dataframe output parameters
    pd.set_option('display.max_rows'    , 200)
    pd.set_option('display.max_columns' , 200)
    pd.set_option('display.max_colwidth', 1000)

    # set jupyter notebook matplotlib figure output default parameters
    matplotlib.rcParams['figure.dpi']     = 200
    matplotlib.rcParams['figure.figsize'] = (4, 4)

    # set the matplotlib figures style
    sns.set_style('whitegrid')


def get_table(data, get_frequency=True):
    """
    Return a count and frequency table of a categorical pandas serie
    → Arguments:
        - data: categorical pandas serie
    """
    # get the count and convert to dataframe
    table = pd.DataFrame(data={'count_': data.value_counts()})

    if get_frequency:
        # create the frequency column and convert to a string like '52.3%'
        total_count = table['count_'].sum()
        table['freq_'] = table.apply(lambda x: '{:.2f}%'.format(100 * x['count_'] / total_count), axis=1)
        
    return table


def print_size(data):
    """
    Print the size of a pandas serie or pandas dataframe
    → Example:
        >>> print_size(dataframe)
            Size: 1354 x 6
        >>> print_size(serie)
            Size: 1354
    → Arguments:
        - data: pandas serie or pandas dataframe
    """
    shape = data.shape

    if len(shape) == 2:
        print('Size: {} x {}'.format(shape[0], shape[1]))
    else:
        print('Size: {}'.format(shape[0]))


def plot_categorical_feature(data, feature_name, data_name='?', stratifier_feature_name=None, max_number=50, save_figure=False, figure_path='./temp.png', figsize=(17, 3), legend_fontsize=13):
    """
    Categorical feature barplot
    → Arguments:
        - data                   : pandas dataframe
        - feature_name           : name of the categorical feature to plot
        - data_name              : string representing the dataframe name
        - stratifier_feature_name: if specified, color the barplot by this feature
        - max_number             : number of categories to plot (top 50 by default)
        - save_figure            : if set to True saves the figure at the given path
        - figure_path            : path where to save the figure at

    ⚠️ Color handling is way too basic still.
    """
    
    max_number = min(max_number, data[feature_name].nunique())
        
    # plot feature distribution
    count_table = data[feature_name].value_counts()
    if stratifier_feature_name:
        dd = data.copy()
        dd = pd.crosstab(dd[feature_name], dd[stratifier_feature_name]).reindex(count_table.index)
        color = sns.color_palette('Set2', 6)
        
        stratifier_count_table = data[stratifier_feature_name].value_counts()
        dd = dd[stratifier_count_table.index]
    else:
        dd = count_table
        color = '#1C6CAB'
    dd.head(max_number).plot(kind='bar', figsize=figsize, linewidth=0, width=0.8, legend=False, stacked=True, color=color)    
        
    # set title
    title = '{} distribution of {} (top {:,}/{:,} - {:,} entries)'.format(feature_name, data_name, max_number, data[feature_name].nunique(), data.shape[0])
    if stratifier_feature_name:
        title += ' stratified by {}'.format(stratifier_feature_name)
    plt.title(title, loc='left', fontsize=15)
    
    # set axis legend
    plt.xlabel(feature_name)
    plt.ylabel('count')
    
    # set stratifier legend
    if stratifier_feature_name:
        leg = plt.legend(bbox_to_anchor=(0.9, 0.8), title=stratifier_feature_name, fontsize=legend_fontsize)
        plt.setp(leg.get_title(), fontsize=legend_fontsize)
        
    # set plot format
    plt.gca().xaxis.grid(False) # remove xaxis grid line
    sns.despine()               # remove right and top frame border
    
    # save figure
    if save_figure:
        plt.savefig(figure_path, bbox_inches='tight')
    
    plt.show()
