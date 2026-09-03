# ---------------------------------------------------------------------------
# Lê o cabeçalho de cada ação em acoes/ e monta uma tabela única. Usado pelo
# Painel e pela capa, para que os dois nunca fiquem dessincronizados — mexer
# no cabeçalho de uma ação atualiza os dois ao mesmo tempo, sozinho.
# ---------------------------------------------------------------------------
library(dplyr)

MESES <- c("Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
           "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")

.campo <- function(fm, nome, padrao = NA) {
  v <- fm[[nome]]
  if (is.null(v) || length(v) == 0) return(padrao)
  v
}

ler_acoes <- function() {
  arquivos <- list.files("acoes", pattern = "\\.qmd$", full.names = TRUE)
  arquivos <- arquivos[!startsWith(basename(arquivos), "_")]   # _modelo.qmd não conta

  acoes <- lapply(arquivos, function(f) {
    fm <- rmarkdown::yaml_front_matter(f)
    cats <- as.character(.campo(fm, "categories", character(0)))
    tibble::tibble(
      arquivo       = basename(f),
      titulo        = as.character(.campo(fm, "title", "")),
      subtitulo     = as.character(.campo(fm, "subtitle", "")),
      data          = as.Date(as.character(.campo(fm, "date", NA))),
      categorias    = list(cats),
      participantes = suppressWarnings(as.numeric(.campo(fm, "participantes"))),
      horas         = suppressWarnings(as.numeric(.campo(fm, "horas"))),
      publico       = as.character(.campo(fm, "publico", NA)),
      campus        = as.character(.campo(fm, "campus", NA)),
      cursos        = list(as.character(.campo(fm, "cursos", character(0))))
    )
  }) |> bind_rows()

  acoes |>
    mutate(
      mes   = purrr::map_chr(categorias, \(x) { m <- x[x %in% MESES]; if (length(m)) m[1] else NA_character_ }),
      # Eixo é "toda etiqueta que não é mês".
      eixos = purrr::map(categorias, \(x) x[!x %in% MESES])
    )
}
