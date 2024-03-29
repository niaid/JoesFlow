#' The application User-Interface
#'
#' @export
#' @importFrom shiny br
#' @importFrom shiny brushOpts
#' @importFrom shiny column
#' @importFrom shiny downloadButton
#' @importFrom shiny fileInput
#' @importFrom shiny fluidRow
#' @importFrom shiny h4
#' @importFrom shiny HTML
#' @importFrom shiny mainPanel
#' @importFrom shiny navbarPage
#' @importFrom shiny numericInput
#' @importFrom shiny plotOutput
#' @importFrom shiny radioButtons
#' @importFrom shiny selectInput
#' @importFrom shiny selectizeInput
#' @importFrom shiny sidebarPanel
#' @importFrom shiny sliderInput
#' @importFrom shiny tabsetPanel
#' @importFrom shiny tabPanel
#' @importFrom shiny tagList
#' @importFrom shiny tags
#' @importFrom shiny uiOutput
app_ui <- function() {
  tagList(
    # Your application UI logic
    navbarPage(title = "Joe's Flow",
               id = "nav_bar",
               tabPanel("Upload",
                        sidebarPanel(
                          fileInput("file1", "Choose Flow File",
                                    accept = c(
                                      "text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")
                          ),
                          fileInput("file2", "Choose Metadata File",
                                    accept = c(
                                      "text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")


                          ),
                          sliderInput("subsample",
                                      "How much subsampling?",
                                      value = 0.2,
                                      min = 0,
                                      max = 1)
                        ),
                        mainPanel(
                          DT::DTOutput('contents'),
                          DT::DTOutput('metadata')
                        )
               ),
               tabPanel("Visualize",
                        sidebarPanel(
                          uiOutput("meta_sel"),

                          br(),

                          # Input: Slider for the number of observations to generate ----
                          selectInput("clust_type", label = "Select Clustering Method",
                                      choices=c("Kmeans", "Hierarchical"), selected="Kmeans"),
                          uiOutput("cluster_setting"),
                          uiOutput("col_pal"),
                          uiOutput("show_dimreduct_legend"),
                          radioButtons("show_hide_cluster_legend",
                                       "Cluster Legend",
                                       choices = c('Show', 'Hide'),
                                       selected = 'Show'),

                          fluidRow(downloadButton('pca_coord_download', label = "PCA coords")),
                          fluidRow(downloadButton('umap_coord_download', label = "UMAP coords")),
                          fluidRow(downloadButton('tsne_coord_download', label = "tSNE coords")),
                          fluidRow(column(6, numericInput("download_height", "Download Height",
                                                          min=1, max=50, step=1, value=10)),
                                   column(6, numericInput("download_width", "Download Width",
                                                          min=1, max=50, step=1, value=15))),

                          numericInput('seed', 'Random Seed:', value = 247893, min = 1)

                        ),
                        mainPanel(
                          tabsetPanel(id = 'main_output',
                                      type = "tabs",
                                      tabPanel("Features",
                                               fluidRow(column(6,
                                                               plotOutput("feats_plot")),
                                                        column(6,
                                                               plotOutput("sample_var"))),
                                               fluidRow(column(6, downloadButton('feat_download')))
                                      ),
                                      tabPanel("PCA",
                                               fluidRow(column(6,
                                                               plotOutput("pca_plot")),
                                                        column(6,
                                                               plotOutput("pca_k_plot"))),
                                               fluidRow(column(12,
                                                               plotOutput("samp_p_pca"))),
                                               fluidRow(column(6,
                                                               downloadButton("pca_download", label='Download Plot'),
                                                               downloadButton("pca_download_vals", label='Download Values')),
                                                        column(6, downloadButton("pca_download_loading", label='Download Loadings'))
                                               )
                                      ),
                                      tabPanel("UMAP",
                                               fluidRow(column(6,
                                                               plotOutput("umap_plot")),
                                                        column(6,
                                                               plotOutput("umap_k_plot"))),
                                               fluidRow(column(12,
                                                               plotOutput("samp_pca")
                                               )),
                                               fluidRow(column(6,
                                                               downloadButton("umap_download", label='Download Plot'),
                                                               downloadButton("umap_download_vals", label='Download Values')),
                                                        column(6, downloadButton("umap_download_loading", label='Download Loadings'))
                                               )
                                      ),
                                      tabPanel("TSNE",
                                               fluidRow(column(6,
                                                               plotOutput("tsne_plot")),
                                                        column(6,
                                                               plotOutput("tsne_k_plot"))),
                                               fluidRow(column(12,
                                                               plotOutput("samp_t_pca"))),
                                               fluidRow(column(6,
                                                               downloadButton("tsne_download", label='Download Plot'),
                                                               downloadButton("tsne_download_vals", label='Download Values')),
                                                        column(6, downloadButton("tsne_download_loading", label='Download Loadings'))
                                               )
                                      ),
                                      tabPanel("Composition",
                                               fluidRow(
                                                 column(width = 12,
                                                        h4("Click & Drag for plot details"),
                                                        DT::dataTableOutput("click_info")
                                                 )
                                               ),
                                               fluidRow(column(12,
                                                               plotOutput("composition_ui",
                                                                          click = "plot1_click",
                                                                          brush = brushOpts(id = "plot1_brush")))),
                                               fluidRow(
                                                 column(6, downloadButton('comp_download', label="Download Plot")),
                                                 column(6, downloadButton('comp_download_table', label="Download Table"))
                                               ),
                                               fluidRow(column(12, selectizeInput("feat_dim", "Select Dimension Reduction",
                                                                                  choices=c(" ", "PCA", "UMAP", "tSNE"), selected=" "))),
                                               fluidRow(column(12, uiOutput("comp_ui"))),
                                               fluidRow(column(6, downloadButton('comp_feat_download')))
                                      ),
                                      tabPanel("Markers",
                                               fluidRow(column(12,
                                                               plotOutput("marker_heat", height = "700px"))
                                               ),
                                               fluidRow(column(6, downloadButton('heat_download')))
                                      )
                          )
                        )
               ),
               tabPanel(HTML(" </a></li><li><a href=\"https://www.niaid.nih.gov/research/png-loke-phd\">Type 2 Immunity Section,<br>Laboratory of Parasitic Diseases, NIAID")),
               header = tags$head(
                 tags$style(HTML(
                    # changes to font of "Joe's Flow" in header
                    ".navbar-default .navbar-brand {color: #df691a; font-size:28}", # changes color
                    ".navbar-default .navbar-brand:hover {color: #df691a;}",        # changes color (on hover)
                    '.navbar-header {font-family: "Brush Script MT"}',              # changes font
                    '.navbar-brand { font-size: 48px}',                             # changes font size

                    # adds padding around text in header
                    '.navbar-nav > li > a, .navbar-brand {
                      padding-top:30px !important;
                      padding-bottom:0 !important;
                      height: 80px;
                    }',

                    # makes lab link float to the right of the header
                    '.navbar-nav {
                      float: none !important;
                    }
                    .navbar-nav > li:nth-child(4) {
                      float: right;
                      right: 75px;
                    }.',

                    # background color and formatting of header block
                    'h3, .h3 { font-size: 12px}',
                    '.navbar {min-height:80px !important;}',
                    '.navbar { background-color: #2c3e4f;}',

                    # changes to font of tab titles
                    '.navbar-default .navbar-nav > li > a {color:#df691a;}',
                    '.navbar-default .navbar-nav > .active > a,',
                    '.navbar-default .navbar-nav > .active > a:focus,',
                    '.navbar-default .navbar-nav > .active > a:hover {color: white;font-size:18px;background-color:#2c3e4f}',
                    '.navbar-default .navbar-nav > li > a:hover {color: white;background-color:#2c3e4f;text-decoration:underline;}',

                    # ???
                    ".navbar-default .navbar-nav > li > a[data-value='t1'] {color: red;background-color: pink;}",
                    ".navbar-default .navbar-nav > li > a[data-value='t2'] {color: blue;background-color: lightblue;}",
                    ".navbar-default .navbar-nav > li > a[data-value='t3'] {color: green;background-color: lightgreen;}"
                 )))
    )
  )
}
