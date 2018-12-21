library('RColorBrewer')
library('ggplot2')
suppressPackageStartupMessages(library('tidyverse'))
suppressPackageStartupMessages(library('survival'))
suppressPackageStartupMessages(library('survminer'))

print_size <- function(data) {
    # Print the size of a dataframe
    cat(sprintf("Size of %s: %d x %d", deparse(substitute(data)), nrow(data), ncol(data)))
}

set_notebook_plot_size <- function(width, height) {
    # Set the size of the plot in jupyter notebook
    options(repr.plot.width = width, repr.plot.height = height)
}

get_table <- function(data, sum = TRUE, remove_null_values = FALSE) {
    # print a custom sorted table of a categorical feature (with count and frequency)
    count_table <- rev(sort(table(data)))

    prop_table  <- round(prop.table(count_table) * 100, 1)
    
    summary <- data.frame(names(count_table),
                          as.vector(count_table),
                          paste0(as.character(prop_table), "%"))
    
    colnames(summary) <- c("values", "count", "freq")
    
    if (remove_null_values)
        summary <- summary[summary$count > 0,]

    if (sum)
        summary <- rbind(summary, data.frame("values" = "-- total --", "count" = length(data), "freq" = "100%"))

    return (summary)
}

get_colors <- function(n, add_color = c()) {
    # Return a vector of n divergent and nice-looking colors
    # → Ex : get_colors(3, add_color = c('grey', 'blue')) ⟹ c('#9E0142', '#FEE08B', '#88CFA4', 'grey', 'blue')
    # → Arguments
    #     - n        : number of colors
    #     - add_color: if specified, add the given color vector at the end of the generated color vector
    
    colors <- c()
    
    if (n >= 5)
        colors <- colorRampPalette(brewer.pal(11, "Spectral"))(n)
    else
        colors <- c('#9E0142', '#FEE08B', '#88CFA4', '#5E4FA2')[1:n]
    
    return (c(colors, add_color))
}

plot_survival_curve <- function(data, stratifier_column_name, colors, line_size = 0.5, legend_size = 8, legend_interspace = 1.2, surv_diag_years = 'OS', surv_status = 'OS_Status') {
    # Plot the survival curve of the given data on the given stratifier
    # → Arguments
    #     - data
    #     - stratifier_column_name: name of the column on which to stratify the survival plot
    #     - colors                : vector of colors of the same size as the number of stratification
    #     - line_size
    #     - legend_size
    #     - legend_interspace     : y space between legend lines
    #     - surv_diag_years       : formula variable 1
    #     - surv_status           : formula variable 2
    
    # evaluate the survival curve
    formula <- sprintf('Surv(%s, %s) ~ %s', surv_diag_years, surv_status, stratifier_column_name)
    surv_fit <- surv_fit(as.formula(formula), data = data)
    
    # set legend labels
    short_names <- sapply(names(surv_fit$strata), function (s) strsplit(s, '=')[[1]][[2]])
    legend_labels <- sprintf('%s (n = %s)', short_names, surv_fit$strata)
    
    # create plot object
    ggsurv <- ggsurvplot(surv_fit,
                         censor = FALSE,
                         palette = colors,
                         linetype = 'solid',
                         size = line_size,
                         xlab = 'years',
                         ylab = 'survival probability',
                         legend = c(0.6, 0.8),
                         legend.title = '',
                         legend.labs = legend_labels,
                         font.tickslab = legend_size,
                         font.x = legend_size,
                         font.y = legend_size)
                          
    # modify plot object legend properties
    ggsurv$plot <- ggsurv$plot + theme(legend.text = element_text(size = legend_size), legend.key.size = unit(legend_interspace, 'lines'))

    # return ggplot object
    return (ggsurv$plot)
}

plot_survival_curve_stratified_by_categorical_feature <- function(data, mask, wildtype_mask, stratifier_column_name, legend_prefix, colors, remove_na = FALSE, wildtype_name = 'wildtype') {
    # Plot the survival curve of the given data on the given stratifier with the given mask and wildtypes
    # → Arguments
    #     - data
    #     - mask                  : mask of the data on which to stratify
    #     - wildtype_mask         : mask for the wildtype
    #     - stratifier_column_name: name of the column on which to stratify the survival plot
    #     - legend_prefix         : prefix for the masked and stratified legend
    #     - colors                : vector of colors of the same size as the number of stratification
    #     - remove_na             : if TRUE remove NA on stratifier
    #     - wildtype_name         : name of the wildtype curve
    
    # create stratification
    data$stratify <- wildtype_name
    
    if (stratifier_column_name == '')
        data[mask, 'stratify'] <- legend_prefix
    else
        data[mask, 'stratify'] <- sprintf('%s%s', legend_prefix, data[mask, stratifier_column_name])
    data <- data[mask | wildtype_mask,]

    # remove NA values
    if (stratifier_column_name != '' & remove_na)
        data <- data[wildtype_mask | (mask & ! is.na(data[,stratifier_column_name])),]
    
    # plot
    return (plot_survival_curve(data, 'stratify', colors))
}
