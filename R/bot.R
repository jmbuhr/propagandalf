## Telegram Bot
library(telegram.bot)
library(meme)

token <- bot_token("propagandalf")
bot <- Bot(token)
updater <- Updater(token)



start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hello %s!", update$message$from$first_name))
}

gandalf <- function(bot, update, args) {
  chat_id <- update$message$chat_id
  # message(chat_id)
  if (length(args >= 1L)) {
    text <- paste(args, collapse = " ")
    text <- stringr::str_split(text, ";")[[1]]
    upper <- text[1]
    if (length(text) >= 2) {
      lower <- text[2:length(text)]
    } else {
      lower <- ""
    }
    templates <- dir("img", full.names = TRUE)
    img_path <- sample(templates, 1)

    img <- magick::image_read(img_path)
    prop <- magick::image_info(img)
    tmp <- tempfile(fileext = ".png")
    m <- meme(img = img_path,
              font = "Helvetica",
              upper = upper,
              lower = lower)
    png(tmp,
        width = prop$width,
        height = prop$height)
    print(m)
    dev.off()
    bot$sendPhoto(chat_id = chat_id,
                  photo = tmp)
    request <- glue::glue("https://api.telegram.org/bot{bot_token('propagandalf')}/sendPhoto?chat_id={chat_id}")
    # httr::POST(request,
    #            body = list(photo = httr::upload_file(tmp, type = "png")),
    #            encode = "multipart")
  } else {
    bot$sendMessage(chat_id = chat_id,
                    text = "Is there something you want me to meme? Pass is right after the command (and you SHALL pass). Separate upper and lower text by semicolon ;")
  }
}

error_callback <- function(bot, error) {
  warning(simpleWarning(conditionMessage(error), call = "Updates polling"))
}

updater <- updater +
  ErrorHandler(error_callback) +
  CommandHandler("start", start) +
  CommandHandler("gandalf", gandalf, pass_args = TRUE)

updater$start_polling()


