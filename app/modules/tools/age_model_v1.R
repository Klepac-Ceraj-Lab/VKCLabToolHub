# modules/home.R

age_model_v1_ui <- function(id) {
  tagList(
    # Header banner
    # div(tags$img(src ="assets/Age-Model.png")),
    div(class = "header-banner", "Age Model V1"),

    # Inline button gallery that scrolls (via simple anchor links)
    div(class = "button-gallery",
        # Each button has an onclick that jumps to an anchor on the page.
        actionButton(NS(id, "btn_flavor"), "About", onclick = "document.getElementById('flavorText').scrollIntoView({behavior: 'smooth'});"),
        actionButton(NS(id, "btn_form"), "Submission Form", onclick = "document.getElementById('submissionForm').scrollIntoView({behavior: 'smooth'});"),
        actionButton(NS(id, "btn_cite"), "Cite", onclick = "document.getElementById('citations').scrollIntoView({behavior: 'smooth'});"),
        actionButton(NS(id, "btn_runs"), "Cite", onclick = "document.getElementById('runs').scrollIntoView({behavior: 'smooth'});")
    ),

    # Flavor text section with an anchor
    div(id = "flavorText", class = "section",
        h3("About Age Model V1"),
        p("Welcome to our web platform, designed to make the predictive model from our recent study, “Early life microbial succession in the gut follows common patterns in full-term and preterm infants”, accessible to researchers and healthcare professionals."),
        p("Our research focused on the early-life development of the gut microbiome, revealing consistent patterns across diverse populations (3154 stool samples, 1600 subjects, 12 studies, 12 countries, 4 continents). We identified key microbial taxa that serve as predictors of age, including declines in Bifidobacterium species and increases in Faecalibacterium prausnitzii and members of the Lachnospiraceae family."),
        p("This web form allows users to input specific microbial data to estimate the developmental stage of the gut microbiome, leveraging the predictive capabilities of our model. Our goal is to provide researchers and healthcare professionals with a practical tool to assess and monitor gut microbiome maturation in early life."),
        p("Please note: This tool is intended for research and educational purposes only and should not be used for clinical diagnosis or treatment without consultation from qualified healthcare providers."),
        actionButton(NS(id, "btn_form2"), "Try the Age Model!", onclick = "document.getElementById('submissionForm').scrollIntoView({behavior: 'smooth'});")
    ),

    # Submission Form Section with an anchor
    div(id = "submissionForm", class = "section",
        h2("Gut Microbiome Age Prediction - Submission Form"),
        fluidRow(
          column(6,
                 # Job ID
                 textInput(NS(id, "jobId"), "Job ID", placeholder = "Leave blank for auto-generation"),
                 # User Name
                 textInput(NS(id, "userName"), "Name", placeholder = "e.g., Jane Doe"),
                 helpText("Used only in the submission table unless alias is selected below."),
                 # Email Address (using emailInput for HTML5 validation)
                 textInput(NS(id, "email"), "Email address", placeholder = "you@example.com"),
                 helpText("We'll send your results here. Your email will not be shared."),
                 # MP3 Profiles upload
                 fileInput(NS(id, "mp3Profiles"), "Upload MP3 Profiles",
                           accept = c(".tsv", ".csv", ".zip"), multiple = FALSE),
                 helpText("Required: One or more MetaPhlAn3 taxonomic profiles."),
                 # Age Metadata upload
                 fileInput(NS(id, "ageMetadata"), "Upload Age Metadata (Optional)",
                           accept = c(".tsv", ".csv")),
                 helpText("Include subject ID and age (in days/months). Required for benchmarking or research contribution.")
          ),
          column(6,
                 # Toggles using checkboxes (you can later adjust to switch style if needed)
                 div(
                   checkboxInput(NS(id, "maskName"), HTML("&#128373; Mask my name with an alias on the submission table"), FALSE),
                   checkboxInput(NS(id, "runBenchmark"), HTML("&#128202; Perform benchmarking if metadata is provided and validated"), FALSE),
                   checkboxInput(NS(id, "allowContribution"), HTML("&#129302; I agree to contribute validated metadata to improve the model"), FALSE),
                   helpText("Anonymized data will only be stored if this is selected and metadata is validated.")
                 ),
                 # Submit Button
                 actionButton(NS(id, "submitAnalysis"), "Submit Analysis", class = "btn btn-primary")
          )
        )
    ),

    # Citation
    div(
      id = "citation",
      style = "background-color: #f8f9fa; margin-top: 20px; padding: 20px; border-radius: 5px;",
      p("If you use this tool in your manuscript, thesis, or report, please consider citing:"),
      tags$blockquote(
        "Fahur Bottino, G., Bonham, K. S., Patel, F., McCann, S., Zieff, M., Naspolini, N., Ho, D.,",
        " Portlock, T., Joos, R., Midani, F. S., Schüroff, P., Das, A., Shennon, I., Wilson, B. C.,",
        " O'Sullivan, J. M., Britton, R. A., Murray, D. M., Kiely, M. E., Taddei, C. R.,",
        " Beltrão-Braga, P. C. B., … Klepac-Ceraj, V. (2025).",
        " Early life microbial succession in the gut follows common patterns in humans across the globe.",
        " Nature communications, 16(1), 660. ",
        tags$a(href="https://doi.org/10.1038/s41467-025-56072-w", "https://doi.org/10.1038/s41467-025-56072-w")
      ),
      p("BibTeX:"),
      tags$pre("
        @article{Bottino2025,
          title={Early life microbial succession in the gut follows common patterns in humans across the globe},
          author={Fahur Bottino, G. and Bonham, K. S. and Patel, F. and McCann, S. and Zieff, M. and
                   Naspolini, N. and Ho, D. and Portlock, T. and Joos, R. and Midani, F. S. and
                   Schüroff, P. and Das, A. and Shennon, I. and Wilson, B. C. and O'Sullivan, J. M. and
                   Britton, R. A. and Murray, D. M. and Kiely, M. E. and Taddei, C. R. and
                   Beltrão-Braga, P. C. B. and Klepac-Ceraj, V.},
          journal={Nature communications},
          volume={16},
          number={1},
          pages={660},
          year={2025},
          doi={10.1038/s41467-025-56072-w}
        }
      ")
    ),

    # Runs
    div(
      id = "runs",
      style = "background-color: #f8f9fa; margin-top: 20px; padding: 20px; border-radius: 5px;",
      h3("Submission History"),
      DTOutput(NS(id, "history_table"))
    )
  )
}

age_model_v1_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Path to database file
    db_path <- "databases/age_model_v1.sqlite"
    dir.create(dirname(db_path), showWarnings = FALSE, recursive = TRUE)

    # Connect to database and create table if it doesn't exist
    conn <- dbConnect(SQLite(), db_path)
    onSessionEnded(function() { dbDisconnect(conn) })
    dbExecute(conn, "
      CREATE TABLE IF NOT EXISTS runs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobId TEXT,
        userName TEXT,
        email TEXT,
        maskName INTEGER,
        runBenchmark INTEGER,
        allowContribution INTEGER,
        submitted_at TEXT,
        ip TEXT,
        status TEXT,
        uuid TEXT,
        message TEXT
      );
    ")

    runs_data <- reactiveVal({
      df <- dbGetQuery(conn, "SELECT * FROM runs ORDER BY submitted_at DESC")

      # 1) Status badge: green if completed, red if error
      df$pretty_status <- ifelse(
        df$status == "completed",
        '<span class="badge bg-success">Completed</span>',
        '<span class="badge bg-danger">Error</span>'
      )

      # 2) Download button only for completed
      df$download <- ifelse(
        df$status == "completed",
        sprintf(
          '<a href="http://10.131.0.41:1025/age_model_v1/download/%s" target="_blank" class="btn btn-sm btn-primary" download>Download</a>',
          df$uuid
        ),
        ""   # empty string → no button
      )

      # (optional) drop the raw status column so you don’t show it twice
      df$status <- NULL

      df
    })

    output$history_table <- DT::renderDataTable(
      runs_data(),
      escape = FALSE, selection = 'none', server = FALSE,
      options = list(dom = 't', paging = FALSE, ordering = FALSE)
    )

    # Observe the submit button, then print submitted values and run analysis
    observeEvent(input$submitAnalysis, {
      print(paste0("Job ID: ", input$jobId))
      print(paste0("User Name: ", input$userName))
      print(paste0("Email: ", input$email))
      print(paste0("Mask Name: ", input$maskName))
      print(paste0("Run Benchmark: ", input$runBenchmark))
      print(paste0("Allow Contribution: ", input$allowContribution))

      # 1) show modal
      showModal(modalDialog(
        title = "Processing...",
        "Please wait while your analysis runs on the server.",
        footer = NULL
      ))

      # 2) prepare multipart body
      body_list <- list(
        jobId           = input$jobId,
        userName        = input$userName,
        email           = input$email,
        maskName        = as.character(as.integer(input$maskName)),
        runBenchmark    = as.character(as.integer(input$runBenchmark)),
        allowContribution = as.character(as.integer(input$allowContribution))
      )

      # attach MP3 profiles
      if (!is.null(input$mp3Profiles)) {

        orig_path <- input$mp3Profiles$datapath
        ext       <- file_ext(orig_path) # e.g. "csv"
        new_name  <- paste0("mp3_profiles.", ext)
        dst       <- file.path(tempdir(), new_name)

        print(dst)

        file.copy(orig_path, dst, overwrite = TRUE)

        body_list[["mp3Profiles"]] <- upload_file(
          dst,
          type = mime::guess_type(new_name)
        )

      }
      # attach optional age metadata
      if (!is.null(input$ageMetadata)) {

        orig_path <- input$ageMetadata$datapath
        ext       <- file_ext(orig_path) # e.g. "csv"
        new_name  <- paste0("age_metadata.", ext)
        dst       <- file.path(tempdir(), new_name)

        print(dst)

        file.copy(orig_path, dst, overwrite = TRUE)
        body_list[["ageMetadata"]] <- upload_file(
          dst,
          type = mime::guess_type(new_name)
        )

      }

      # 3) send the POST
      resp <- tryCatch(
        POST("http://10.131.0.41:1025/age_model_v1/prediction", body = body_list, encode = "multipart"),
        error = function(e) e
      )

      # Process response received
      status      <- "error"
      message_txt <- NULL
      result_uuid <- NA_character_

      if (inherits(resp, "error")) {
        # network-level failure (timeout, unreachable, etc)
        message_txt <- conditionMessage(resp)

      } else {
        # we got an HTTP response
        code   <- status_code(resp)
        # try JSON parse, but fall back to raw text
        parsed <- tryCatch(
          content(resp, "parsed", simplifyVector = TRUE),
          error = function(e) list(message = content(resp, "text", encoding="UTF-8"))
        )

        if (code == 200L) {
          status      <- "completed"
          message_txt <- parsed$message %||% "No message field in response"
          result_uuid <- parsed$uuid    %||% NA_character_
        } else {
          status      <- "error"
          # if the server sent a “message” field in JSON, use that;
          # otherwise show the HTTP code and raw text
          message_txt <- parsed$message %||%
            sprintf("HTTP %s: %s", code, content(resp, "text", encoding="UTF-8"))
        }
      }

      # client IP
      ip <- session$request$HTTP_X_FORWARDED_FOR %||%
        session$request$REMOTE_ADDR %||%
        "unknown"

      # 5) log to SQLite
      DBI::dbExecute(conn, "
        INSERT INTO runs
          (jobId, userName, email, maskName, runBenchmark,
           allowContribution, submitted_at, ip, status, uuid, message)
        VALUES
          (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ", params = list(
        input$jobId,
        input$userName,
        input$email,
        as.integer(input$maskName),
        as.integer(input$runBenchmark),
        as.integer(input$allowContribution),
        as.character(Sys.time()),
        ip,
        status,
        result_uuid,
        message_txt
      ))

      # 6) dismiss modal & notify
      removeModal()
      if (status == "completed") {
        showNotification(message_txt, type = "message")
      } else {
        showNotification(message_txt, type = "error")
      }

      # You can also access file inputs via input$mp3Profiles and input$ageMetadata.
      # Further processing and validation should be added here.
    })

    # If you need to do reactive processing, file validations, or call other computations,
    # add that logic here.

  })
}
