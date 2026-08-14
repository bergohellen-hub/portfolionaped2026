# Portfólio de Ações do NAPED — 2026

Registro das iniciativas do Núcleo de Apoio Pedagógico e Experiência Docente
do Centro Universitário Afya de São João del-Rei.

**Site:** <https://bergohellen-hub.github.io/portfolionaped2026/>

---

## Vai acrescentar uma ação?

**Leia o [Manual](https://bergohellen-hub.github.io/portfolionaped2026/manual.html).**
Ele explica tudo passo a passo, com imagens, e tem também
[versão em PDF](https://bergohellen-hub.github.io/portfolionaped2026/manual.pdf).

O resumo é:

1. suba as fotos para `fotos/`
2. copie [`acoes/_modelo.qmd`](acoes/_modelo.qmd) para um arquivo novo em `acoes/`
3. preencha e salve

Nenhum outro arquivo precisa ser editado. O menu, a página inicial, a página
do mês e o Painel se atualizam sozinhos.

---

## Como o site é feito

Escrito em [Quarto](https://quarto.org). A estrutura é escrita uma vez; o
conteúdo é um arquivo por item.

```
_quarto.yml          menu, tema e publicação — o único lugar onde moram
index.qmd            a vitrine: varre acoes/*.qmd e monta os cartões
meses.qmd            a grade de meses, montada a partir das etiquetas
dashboard.qmd        o Painel: lê os cabeçalhos das ações e calcula
manual.qmd           o manual de uso
styles.scss          a aparência
scripts/preparar.R   confere as ações e cria a página do mês que faltar
acoes/               uma ação por arquivo  ← é aqui que se trabalha
meses/               páginas de mês (geradas)
paginas/             Equipe, MOVE, Mentoria, Preceptoria, Comprovações, SDD
fotos/               as imagens, como arquivos
```

Uma ação nunca é copiada para mais de um lugar. Ela declara suas etiquetas
(`categories:`) e as páginas a encontram por consulta — a mesma ideia de um
banco de dados.

## Conferência automática

Antes de cada publicação, `scripts/preparar.R` confere todas as ações:
etiqueta de mês válida, fotos existentes, campos obrigatórios, datas,
números. Se algo estiver errado, a publicação **para** com uma explicação em
português, e o site no ar continua intacto.

O mesmo script cria a página de um mês novo quando aparece a primeira ação
daquele mês.

## Publicação

O GitHub Actions gera e publica o site a cada push na `main`
(`.github/workflows/publicar.yml`). Não é preciso subir nada à mão.

Para ver o site localmente antes de publicar:

```bash
quarto preview
```

O Painel e a página de meses rodam R — precisam dos pacotes `rmarkdown`,
`knitr`, `dplyr`, `ggplot2`, `purrr`, `tibble` e `DT`.
