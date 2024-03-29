#' @importFrom rChoiceDialogs getDefaultFilters rchoose.files
#' @importFrom base64enc dataURI
#' @importFrom tools file_ext
#' @importFrom htmltools div img HTML
#' @noRd
#' @keywords internal
swipeRaddin <- function() {
  ns <- asNamespace("rChoiceDialogs")
  try(attachNamespace(ns), silent = TRUE)
  filters <- rbind(
    c("Image files", "*.png;*.bmp;*.jpeg;*.jpg;*.gif;*.svg"),
    c("GIF files (*.gif)", "*.gif"),
    c("SVG files (*.svg)", "*.svg"),
    getDefaultFilters()[5L:7L, ]
  )
  paths <- rchoose.files(filters = filters, index = 1L)
  divs <- vector("list", length = length(paths))
  for(i in seq_along(paths)) {
    image <- paths[i]
    ext <- tolower(file_ext(image))
    if(ext == "svg") {
      divs[[i]] <- div(
        class = "swiper-zoom-container",
        HTML(paste0(readLines(image), collapse = ""))
      )
    } else {
      b64 <- dataURI(file = image, mime = paste0("image/", ext))
      divs[[i]] <- div(
        class = "swiper-zoom-container",
        img(src = b64, style = "height: auto; width: auto; margin: auto;")
      )
    }
  }
  wrapper <- do.call(swipeRwrapper, divs)
  swipeR(wrapper, height = "400px", navigationColor = "red", zoom = TRUE)
}
