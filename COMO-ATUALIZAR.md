# Como publicar uma ação nova

Escrito para ser lido daqui a três meses, sem lembrar de nada.

**A regra que vale para tudo neste projeto:** publicar uma ação é criar
**um arquivo**. Você não edita o menu, nem a página inicial, nem a página do
mês, nem o Painel. Todos eles se atualizam sozinhos.

---

## O caminho curto (quando você já pegou o jeito)

1. Ponha a foto em `fotos/`
2. Crie um arquivo em `acoes/`
3. Preencha o cabeçalho e escreva o texto
4. Commit e push na `main`
5. Espere uns 3 minutos — o site se publica sozinho

O resto deste documento é o passo a passo detalhado.

---

## Passo 1 — Guarde as fotos

Copie as fotos para a pasta `fotos/`.

Dê nomes que digam o que a foto é, **em minúsculas, sem acentos e sem
espaços**:

```
fotos/roda-de-conversa-avaliacao-formativa.jpg
fotos/oficina-metodologias-ativas.jpg
```

Não use `IMG_4821.jpg`. Daqui a um ano você não vai saber o que é.

> **Sobre o tamanho:** fotos de celular servem direto, não precisa
> redimensionar. Só evite passar de uns 2 MB por foto.

---

## Passo 2 — Crie o arquivo da ação

Na pasta `acoes/`, crie um arquivo novo com o nome no formato
`AAAA-MM-descricao-curta.qmd`:

```
acoes/2026-08-roda-de-conversa-avaliacao-formativa.qmd
```

O `.qmd` no final é obrigatório. É o que faz o site reconhecer o arquivo.

---

## Passo 3 — Escreva o cabeçalho

O arquivo começa com um bloco entre duas linhas de três hífens. Este é o
**mínimo** que funciona:

```yaml
---
title: "Roda de conversa sobre avaliação formativa"
description: "Encontro com 22 docentes do Campus Central"
date: 2026-08-18
categories: ["Agosto", "Formação Docente"]
image: ../fotos/roda-de-conversa-avaliacao-formativa.jpg
---
```

Cinco linhas. É isso.

### O que cada linha faz

| Linha | Para que serve |
|---|---|
| `title:` | O título da ação. Aparece no cartão e no topo da página. |
| `description:` | A frase curta embaixo do título, no cartão da vitrine. |
| `date:` | Ordena a vitrine (as mais recentes primeiro). Formato `AAAA-MM-DD`. |
| `categories:` | **O mecanismo principal.** Ver abaixo. |
| `image:` | A foto do cartão. Repare no `../` — o arquivo está uma pasta acima. |

### Sobre o `categories:` — é o que faz tudo funcionar

As etiquetas são o que colocam a ação em vários lugares ao mesmo tempo,
**sem duplicar o arquivo**. Uma ação etiquetada
`["Agosto", "Formação Docente"]` aparece automaticamente:

- na página inicial,
- na página de Agosto,
- no filtro "Formação Docente",
- nos gráficos do Painel.

A lista completa de etiquetas permitidas está no
[CONVENCOES.md](CONVENCOES.md). **Copie e cole de lá.** A comparação é por
texto exato: `Março` funciona, `março` não.

### Campos opcionais

Se você souber os números, acrescente — o Painel soma sozinho:

```yaml
participantes: 22
horas: 4
publico: "Docentes"
campus: "Campus Central"
cursos: ["Medicina"]
```

Se não souber, **omita a linha** ou deixe `~`. Não quebra nada.

---

## Passo 4 — Escreva o texto

Depois do cabeçalho, escreva normalmente. Uma linha em branco separa
parágrafos:

```markdown
No dia 18 de agosto o NAPED reuniu 22 docentes do Campus Central para uma
roda de conversa sobre avaliação formativa.

O encontro discutiu instrumentos de acompanhamento contínuo e o uso de
devolutivas qualitativas ao longo do semestre.
```

### A caixa rosa de destaque

```markdown
::: {.destaque}
Reuniões quinzenais agendadas para o restante do semestre.
:::
```

### As evidências (fotos com legenda)

```markdown
## Evidências

::: {layout-ncol=2}
![**Roda de conversa** Docentes reunidos no auditório.](../fotos/roda-de-conversa-avaliacao-formativa.jpg)

![**Material de apoio** Instrumentos apresentados no encontro.](../fotos/material-roda-de-conversa.jpg)
:::
```

- `layout-ncol=2` põe duas fotos lado a lado. Use `3` para três colunas,
  ou omita o bloco todo se for uma foto só.
- O que está entre `**` vira o título da legenda; o resto, o texto menor.
- Clicar na foto já abre em tela cheia — não precisa fazer nada para isso.

> **Dica:** abra qualquer arquivo que já existe em `acoes/` e use como
> molde. Todos os 27 seguem exatamente este formato.

---

## Passo 5 — Publique

```bash
git add .
git commit -m "Acrescenta ação: roda de conversa sobre avaliação formativa"
git push
```

Ou, pelo site do GitHub: **Add file → Upload files**, arraste os arquivos,
escreva a mensagem e confirme.

Em uns 3 minutos o site está no ar. Para acompanhar, veja a aba **Actions**
do repositório: um ✅ verde quer dizer publicado; um ❌ vermelho, que algo
no arquivo está errado (quase sempre uma aspa faltando no cabeçalho).

---

## Ver antes de publicar (opcional)

Se tiver o [Quarto](https://quarto.org/docs/get-started/) instalado:

```bash
quarto preview
```

Abre o site no navegador e atualiza sozinho a cada vez que você salva.

---

## Casos menos comuns

### Começar um mês novo

Ações de um mês que ainda não tem página aparecem normalmente na página
inicial e no Painel. Para ganharem também uma página própria, são duas
coisas:

1. Copie um arquivo de `meses/` (ex.: `meses/2026-06.qmd`) para
   `meses/2026-08.qmd` e troque o mês nas três linhas onde ele aparece.
2. Acrescente a linha no menu, em `_quarto.yml`, junto dos outros meses.

É a única situação que pede mexer no menu — e só uma vez por mês, não a
cada ação.

### Corrigir uma ação publicada

Edite o arquivo em `acoes/` e dê push. Nada mais.

### Tirar uma ação do ar

Apague o arquivo em `acoes/` e dê push. Ela some da vitrine, da página do
mês e do Painel de uma vez só.

---

## Se algo der errado

| Sintoma | Causa quase certa |
|---|---|
| A ação não aparece na página do mês | Etiqueta de mês escrita diferente da lista do [CONVENCOES.md](CONVENCOES.md) |
| O cartão aparece sem foto | Faltou o `../` no `image:`, ou o nome do arquivo está diferente |
| ❌ vermelho na aba Actions | Aspa ou dois-pontos faltando no cabeçalho |
| A foto não abre em tela cheia | Nada a fazer — funciona sozinho; recarregue a página |

---

## Onde fica cada coisa

```
portfolionaped2026/
├─ _quarto.yml          menu, cores e publicação — mexer é raro
├─ index.qmd            a vitrine (varre acoes/ sozinha)
├─ dashboard.qmd        o Painel (calcula tudo sozinho)
├─ styles.scss          a aparência do site
├─ CONVENCOES.md        a lista de etiquetas permitidas
├─ COMO-ATUALIZAR.md    este arquivo
├─ acoes/               UMA AÇÃO POR ARQUIVO  ← é aqui que você trabalha
├─ meses/               as páginas de mês (consultas por etiqueta)
├─ paginas/             Equipe, MOVE, Mentoria, Preceptoria, Comprovações, SDD
└─ fotos/               as imagens, como arquivos
```
