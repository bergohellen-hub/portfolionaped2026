# Portfólio de Ações do NAPED — 2026

Registro das iniciativas do Núcleo de Apoio Pedagógico e Experiência Docente
do Centro Universitário Afya de São João del-Rei.

**Site:** <https://bergohellen-hub.github.io/portfolionaped2026/>

---

## Vai acrescentar uma ação?

Leia o **[COMO-ATUALIZAR.md](COMO-ATUALIZAR.md)**. O resumo é:

1. ponha a foto em `fotos/`
2. crie um arquivo em `acoes/`
3. `git push`

Nenhum outro arquivo precisa ser editado. O menu, a página inicial, a página
do mês e o Painel se atualizam sozinhos.

As etiquetas permitidas estão no **[CONVENCOES.md](CONVENCOES.md)**.

---

## Como o site é feito

Escrito em [Quarto](https://quarto.org). A estrutura é escrita uma vez; o
conteúdo é um arquivo por item.

```
_quarto.yml          menu, tema e publicação — o único lugar onde moram
index.qmd            a vitrine: varre acoes/*.qmd e monta os cartões
dashboard.qmd        o Painel: lê os cabeçalhos das ações e calcula
styles.scss          a aparência
acoes/               uma ação por arquivo  ← é aqui que se trabalha
meses/               páginas de mês (consultas por etiqueta)
paginas/             Equipe, MOVE, Mentoria, Preceptoria, Comprovações, SDD
fotos/               as imagens, como arquivos
```

Uma ação nunca é copiada para mais de um lugar. Ela declara suas etiquetas
(`categories:`) e as páginas a encontram por consulta — a mesma ideia de um
banco de dados.

## Publicação

O GitHub Actions gera e publica o site a cada push na `main`
(veja `.github/workflows/publicar.yml`). Não é preciso subir nada à mão.

Para ver o site localmente antes de publicar:

```bash
quarto preview
```

O Painel é a única página que roda código (R) — ele precisa dos pacotes
`rmarkdown`, `knitr`, `dplyr`, `ggplot2`, `purrr`, `tibble` e `DT`.
