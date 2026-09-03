# ---------------------------------------------------------------------------
# Roda ANTES de cada publicação (pre-render no _quarto.yml).
#
# Faz duas coisas:
#
#   1. CONFERE cada ação em acoes/. Se algo estiver errado, interrompe a
#      publicação e explica o problema em português — com o arquivo, o que
#      está errado e como consertar. Nada errado vai ao ar.
#
#   2. CRIA a página do mês que ainda não existe. Se aparecer uma ação
#      etiquetada "Agosto" e não houver meses/2026-08.qmd, ele cria.
#
# Roda igual na sua máquina (quarto render / quarto preview) e no GitHub.
# ---------------------------------------------------------------------------

MESES <- c("Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
           "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")

# Os eixos conhecidos. Usar um fora desta lista NÃO impede a publicação —
# só gera um aviso, porque criar um eixo novo é uma decisão legítima.
EIXOS <- c("Formação Docente", "ENAMED", "Projeto MOVE", "Mentoria",
           "Preceptoria", "Produção Científica", "Gestão e Planejamento",
           "Acolhimento", "Podcast Ética Médica", "STHEM")

MANUAL <- "https://bergohellen-hub.github.io/portfolionaped2026/manual.html"

erros <- character(0)
avisos <- character(0)

erro  <- function(arq, ...) erros  <<- c(erros,  sprintf("%s\n     %s", arq, paste0(...)))
aviso <- function(arq, ...) avisos <<- c(avisos, sprintf("%s\n     %s", arq, paste0(...)))

arquivos <- list.files("acoes", pattern = "\\.qmd$", full.names = TRUE)
arquivos <- arquivos[!startsWith(basename(arquivos), "_")]   # _modelo.qmd não conta

if (length(arquivos) == 0) {
  cat("!! Nenhuma ação encontrada em acoes/\n")
  quit(status = 1)
}

meses_usados <- character(0)

for (f in arquivos) {
  nome <- basename(f)

  # --- o nome do arquivo -------------------------------------------------
  if (!grepl("^[0-9]{4}-[0-9]{2}-.+\\.qmd$", nome)) {
    erro(nome, "O nome do arquivo precisa começar com ano e mês.",
         "\n     Exemplo: 2026-08-roda-de-conversa.qmd")
    next
  }
  if (grepl("[A-ZÀ-Ü ]", sub("\\.qmd$", "", nome))) {
    erro(nome, "O nome do arquivo não pode ter maiúsculas, acentos nem espaços.",
         "\n     Use só letras minúsculas sem acento, números e hífen.")
  }

  # --- o cabeçalho -------------------------------------------------------
  fm <- tryCatch(rmarkdown::yaml_front_matter(f), error = function(e) NULL)
  if (is.null(fm)) {
    erro(nome, "O cabeçalho está malformado e não pôde ser lido.",
         "\n     Confira se ele começa e termina com uma linha de três hífens (---)",
         "\n     e se toda frase com dois-pontos está entre aspas.")
    next
  }

  # --- campos obrigatórios ------------------------------------------------
  for (campo in c("title", "date", "categories")) {
    v <- fm[[campo]]
    if (is.null(v) || length(v) == 0 || all(is.na(v)) ||
        (is.character(v) && all(trimws(v) == ""))) {
      erro(nome, sprintf("Falta o campo obrigatório `%s:` no cabeçalho.", campo))
    }
  }

  # --- a data -------------------------------------------------------------
  if (!is.null(fm$date)) {
    # as.Date() LANÇA erro (não devolve NA) em datas impossíveis como
    # 2026-13-45, e derrubaria a conferência antes de checar o resto.
    d <- tryCatch(suppressWarnings(as.Date(as.character(fm$date))),
                  error = function(e) as.Date(NA))
    if (length(d) != 1 || is.na(d)) {
      erro(nome, sprintf("A data `%s` não é válida.", as.character(fm$date)),
           "\n     Use o formato ano-mês-dia, sem aspas. Exemplo: date: 2026-08-18")
    } else {
      prefixo <- substr(nome, 1, 7)
      if (format(d, "%Y-%m") != prefixo) {
        aviso(nome, sprintf("O nome do arquivo diz %s mas a data diz %s.",
                            prefixo, format(d, "%Y-%m")),
              "\n     Não impede a publicação, mas costuma ser engano.")
      }
    }
  }

  # --- as etiquetas -------------------------------------------------------
  cats <- as.character(fm$categories)
  mes <- cats[cats %in% MESES]

  if (length(mes) == 0) {
    quase <- cats[tolower(cats) %in% tolower(MESES)]
    if (length(quase) > 0) {
      certo <- MESES[tolower(MESES) == tolower(quase[1])]
      erro(nome, sprintf("A etiqueta de mês está escrita \"%s\".", quase[1]),
           sprintf("\n     O certo é \"%s\" — a comparação é por texto exato.", certo))
    } else {
      erro(nome, "Falta a etiqueta de mês em `categories:`.",
           "\n     Toda ação precisa de exatamente um mês, escrito assim:",
           sprintf("\n     %s", paste(MESES[1:6], collapse = ", ")), " ...")
    }
  } else if (length(mes) > 1) {
    erro(nome, sprintf("Há mais de uma etiqueta de mês: %s.",
                       paste(mes, collapse = ", ")),
         "\n     Cada ação pertence a um mês só. Se ela se estendeu por dois meses,",
         "\n     costuma ser melhor registrar duas ações.")
  } else {
    meses_usados <- union(meses_usados, mes)
    # A página do mês filtra pelo NOME do arquivo (2026-05-...), mas os
    # botões de filtro da vitrine usam a ETIQUETA. Se as duas discordarem,
    # a ação aparece num mês na página e noutro no filtro.
    n_arq <- as.integer(substr(nome, 6, 7))
    if (!is.na(n_arq) && n_arq >= 1 && n_arq <= 12 && MESES[n_arq] != mes) {
      erro(nome, sprintf("O nome do arquivo diz %s, mas a etiqueta diz \"%s\".",
                         MESES[n_arq], mes),
           sprintf("\n     Use \"%s\" na etiqueta, ou renomeie o arquivo.", MESES[n_arq]),
           "\n     Se discordarem, a ação cai num mês na página e noutro no filtro.")
    }
  }

  # compara sem acento/maiúscula para não acusar "agosto" de ser um eixo
  # desconhecido quando o problema já foi apontado como mês mal escrito
  eixos <- cats[!tolower(cats) %in% tolower(MESES)]
  novos <- eixos[!eixos %in% EIXOS]
  if (length(novos) > 0) {
    aviso(nome, sprintf("Eixo fora da lista conhecida: %s.",
                        paste(sprintf("\"%s\"", novos), collapse = ", ")),
          "\n     Se for intencional, tudo bem — ele já aparece nos filtros e no Painel.",
          "\n     Se foi engano de digitação, confira a lista no manual.")
  }
  if (length(eixos) > 2) {
    aviso(nome, sprintf("São %d eixos. O cartão da vitrine fica cheio com mais de dois.",
                        length(eixos)))
  }

  # --- as fotos -----------------------------------------------------------
  confere_foto <- function(caminho, onde) {
    if (is.null(caminho) || is.na(caminho) || !nzchar(caminho)) return(invisible())
    if (grepl("^https?://", caminho)) return(invisible())
    limpo <- sub("^\\.\\./", "", sub("^/", "", caminho))
    if (!file.exists(limpo)) {
      erro(nome, sprintf("A foto do %s não existe: %s", onde, caminho),
           sprintf("\n     Confira o nome do arquivo dentro da pasta fotos/."))
    }
  }
  confere_foto(fm$image, "cartão (campo image:)")

  texto <- readLines(f, warn = FALSE)
  for (ref in unique(unlist(regmatches(texto,
        gregexpr("(?<=\\]\\()[^)]*fotos/[^)]*", texto, perl = TRUE))))) {
    confere_foto(ref, "corpo do texto")
  }
  for (ref in unique(unlist(regmatches(texto,
        gregexpr("(?<=src=\")[^\"]*fotos/[^\"]*", texto, perl = TRUE))))) {
    confere_foto(ref, "vídeo")
  }

  # --- números ------------------------------------------------------------
  for (campo in c("participantes", "horas")) {
    v <- fm[[campo]]
    if (!is.null(v) && length(v) > 0 && !all(is.na(v))) {
      if (is.na(suppressWarnings(as.numeric(v)))) {
        erro(nome, sprintf("O campo `%s:` precisa ser só o número.", campo),
             sprintf("\n     Está escrito \"%s\". Escreva assim: %s: 22",
                     as.character(v), campo))
      }
    }
  }
}

# ---------------------------------------------------------------------------
# Os endereços antigos, já divulgados, precisam continuar funcionando.
#
# Cada um vive como `aliases:` no cabeçalho da página que herdou o conteúdo,
# e PRECISA começar com barra — sem ela o Quarto cria o redirecionamento
# dentro da subpasta, e o link antigo quebra sem avisar ninguém.
# ---------------------------------------------------------------------------
REDIRECIONAMENTOS <- c(
  "meses/2026-01.qmd"          = "/Portfolio_NAPED_Janeiro_2026.html",
  "meses/2026-02.qmd"          = "/Portfolio_NAPED_Fevereiro_2026.html",
  "meses/2026-03.qmd"          = "/Portfolio_NAPED_Marco_2026.html",
  "meses/2026-04.qmd"          = "/Portfolio_NAPED_Abril_2026.html",
  "meses/2026-05.qmd"          = "/Portfolio_NAPED_Maio_2026.html",
  "meses/2026-06.qmd"          = "/Portfolio_NAPED_Junho_2026.html",
  "paginas/equipe.qmd"         = "/Portfolio_NAPED_Equipe.html",
  "paginas/em-numeros.qmd"     = "/Portfolio_NAPED_Overview.html",
  "paginas/projeto-move.qmd"   = "/Portfolio_NAPED_Projeto_MOVE.html",
  "paginas/mentoria.qmd"       = "/Portfolio_NAPED_Mentoria.html",
  "paginas/preceptoria.qmd"    = "/Portfolio_NAPED_Preceptoria.html",
  "paginas/comprovacoes.qmd"   = "/Portfolio_NAPED_Comprovacoes.html",
  "paginas/sdd-julho.qmd"      = "/portfolio-sdd-2026-2.html"
)

for (arq in names(REDIRECIONAMENTOS)) {
  esperado <- REDIRECIONAMENTOS[[arq]]
  if (!file.exists(arq)) {
    erro(arq, sprintf("Este arquivo sumiu, e com ele o endereço antigo %s.", esperado))
    next
  }
  linhas <- readLines(arq, warn = FALSE)
  if (!any(grepl(sprintf("^\\s*-\\s*%s\\s*$", esperado), linhas))) {
    sem_barra <- sub("^/", "", esperado)
    if (any(grepl(sprintf("^\\s*-\\s*%s\\s*$", sem_barra), linhas))) {
      erro(arq, sprintf("O endereço antigo está escrito sem a barra: %s", sem_barra),
           sprintf("\n     Precisa ser \"%s\" — com a barra na frente. Sem ela,", esperado),
           "\n     o link antigo passa a apontar para dentro da subpasta e quebra.")
    } else {
      erro(arq, sprintf("Falta o endereço antigo %s em `aliases:`.", esperado),
           "\n     Ele já foi divulgado; sem esse redirecionamento, o link quebra.")
    }
  }
}

# ---------------------------------------------------------------------------
# Cria as páginas de mês que ainda não existem
# ---------------------------------------------------------------------------
if (length(erros) == 0) {
  dir.create("meses", showWarnings = FALSE)
  # O ano vem do NOME do arquivo da ação (2027-03-...), nunca de um ano fixo:
  # em janeiro de 2027 as páginas de 2027 nascem sozinhas, e as de 2026
  # continuam mostrando só o que é de 2026.
  prefixos <- unique(substr(basename(arquivos), 1, 7))
  for (ym in sort(prefixos)) {
    alvo <- sprintf("meses/%s.qmd", ym)
    if (file.exists(alvo)) next
    ano <- as.integer(substr(ym, 1, 4))
    n   <- as.integer(substr(ym, 6, 7))
    m   <- MESES[n]
    conteudo <- sprintf('---
title: "%s de %d"
subtitle: "Ações do NAPED"
description: "Registro das iniciativas desenvolvidas pelo NAPED em %s de %d."
toc: false
listing:
  id: mes
  contents: "../acoes/%s-*.qmd"
  type: grid
  grid-columns: 3
  fields: [image, title, description, categories]
  sort: ["ordem asc", "date asc"]
  page-size: 30
  image-height: "172px"
---

::: {#mes}
:::
', m, ano, m, ano, ym)
    writeLines(conteudo, alvo)
    cat(sprintf("   criada a página do mês: %s\n", alvo))
  }
}

# ---------------------------------------------------------------------------
# Relatório
# ---------------------------------------------------------------------------
if (length(avisos) > 0) {
  cat("\n   Avisos (não impedem a publicação):\n\n")
  for (a in avisos) cat("   ·", a, "\n\n")
}

if (length(erros) > 0) {
  cat("\n")
  cat("  ┌──────────────────────────────────────────────────────────────┐\n")
  cat("  │  A publicação foi interrompida                               │\n")
  cat("  └──────────────────────────────────────────────────────────────┘\n\n")
  cat(sprintf("  %s\n\n", ifelse(length(erros) == 1,
      "Há 1 problema para corrigir:",
      sprintf("Há %d problemas para corrigir:", length(erros)))))
  for (e in erros) cat("   ·", e, "\n\n")
  cat(sprintf("  O site continua no ar com a versão anterior — nada foi quebrado.\n"))
  cat(sprintf("  Corrija e salve de novo. O passo a passo está em:\n  %s\n\n", MANUAL))
  quit(status = 1)
}

cat(sprintf("   %d ações conferidas, tudo certo.\n", length(arquivos)))
