custom_css <- tags$style(HTML("
    /* Sidebar background */
    .sidebar {
      display: flex;
      background-color: #0142A4 !important;
      height: 100vh;  /* use 100vh if you need full viewport height */
      flex-direction: column;
      justify-content: space-between;
      padding: 15px;
      box-sizing: border-box;
    }

    /* Base styling for our custom nav buttons */
    .custom-nav-btn {
      background-color: #0142A4;  /* inactive background */
      color: white;               /* inactive text color */
      border: none;
      /* optionally, adjust padding, font-size, etc. */
    }

    .custom-nav-btn:hover {
      background-color: #0C2142;  /* hover state */
      color: white;               /* text remains white on hover */
    }

    /* Active state: when the button is selected */
    .custom-nav-btn.active {
      background-color: white;    /* active background */
      color: #0142A4;             /* active text color */
    }

    /* Gallery container: uses flexbox with wrapping and a fixed gap */
  .gallery {
    display: flex;
    flex-wrap: wrap;
    gap: 20px; /* 20px gap between cards; adjust as needed */
    justify-content: center; /* centers items; optional */
    padding: 10px; /* optional: creates padding around the gallery */
  }

  /* Container for the image: square and rounded */
  .card-img-wrapper {
    position: relative;
    width: 100%;
    height: 0;
    padding-top: 100%; /* Makes the div square */
    overflow: hidden;
    border-radius: 15px; /* Adjust for desired roundness */
    margin-bottom: 10px;
  }
  /* Style for the image inside the wrapper */
  .card-img-top {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  /* Ensure the spotify card respects its container's constraints */
  .spotify-card {
    flex: 0 1 18rem; /* The card will have a base width of 18rem, but can shrink if needed */
    /* margin: 10px;  no need for margins if using gap */
  }

  /* Card body styling */
  .spotify-card .card-body {
    padding: 0.5rem;
  }

  .spotify-card .card-title {
    margin-bottom: 0.25rem;
    font-size: 1.6rem;
    font-weight: bold;
  }

  .spotify-card .card-text {
    font-size: 0.9rem;
    color: #666;
  }

        /* Header Banner: background image, centered large text */
      .header-banner {
        background-image: url('/assets/Age-Model.png');
        background-size: cover;
        background-position: center;
        height: 300px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 48px;
        font-weight: bold;
        margin-bottom: 20px;
      }
      /* Button Gallery: inline buttons spaced out */
      .button-gallery {
        text-align: center;
        margin-bottom: 20px;
      }
      .button-gallery .btn {
        margin: 5px;
      }
      /* Section styling: padding for each major section */
      .section {
        padding: 20px;
        margin-bottom: 20px;
        background-color: #f8f9fa;
        border-radius: 5px;
      }
  "
))
