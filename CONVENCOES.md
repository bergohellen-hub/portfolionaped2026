# Convenções do portfólio

Este arquivo é a **lista fechada** de etiquetas que podem ser usadas nas ações.
Consulte-o sempre que for escrever uma ação nova.

> **A comparação é por texto exato.**
> `Março` e `março` são etiquetas **diferentes**. `Formação Docente` e
> `Formacao Docente` também. Copie e cole daqui — não digite de memória.

---

## 1. Etiqueta de mês (obrigatória, exatamente uma)

Toda ação leva **um** mês. É por ela que a página do mês encontra a ação.

```
Janeiro     Fevereiro   Março       Abril
Maio        Junho       Julho       Agosto
Setembro    Outubro     Novembro    Dezembro
```

Repare no **ç** de `Março`.

---

## 2. Etiquetas de eixo (opcionais, no máximo duas)

O eixo diz *que tipo de trabalho* aquela ação é. Serve para filtrar o
portfólio por tema e alimenta os gráficos do Painel.

| Etiqueta | Quando usar |
|---|---|
| `Formação Docente` | Capacitações, treinamentos, oficinas, NAPED Day, SDD |
| `ENAMED` | Tudo ligado ao ENAMED: preparação, alinhamentos, editais |
| `Projeto MOVE` | Encontros com a educação básica |
| `Mentoria` | Projeto Mentoria: formação e acompanhamento de mentores |
| `Preceptoria` | Preceptores, internato, campos de prática |
| `Produção Científica` | Publicações, fóruns, congressos, premiações |
| `Gestão e Planejamento` | Reuniões institucionais, metas, alinhamentos, visitas |
| `Acolhimento` | Recepção de calouros e docentes, cerimônias, cuidado |
| `Podcast Ética Médica` | Episódios do podcast de Ética Médica (Prof. Pedro Delabrida) |

**Por que no máximo duas:** o cartão da ação na vitrine fica ilegível com
muitas etiquetas. Se uma ação parece pedir três eixos, provavelmente são
duas ações diferentes.

**Uma ação pode ter dois eixos** e aparece nos dois filtros — continua sendo
um arquivo só. O `Projeto Mentoria ENAMED`, por exemplo, é
`[Maio, Mentoria, ENAMED]`.

---

## 3. Precisa de um eixo novo?

Acrescente a linha aqui **e** use a etiqueta na ação. Os botões de filtro da
vitrine se montam sozinhos a partir do que existe nos arquivos — mas o
gráfico "por eixo" do Painel usa uma lista própria (`EIXOS`, no início de
`dashboard.qmd`): acrescente o eixo novo lá também, ou ele não entra nesse
gráfico.

Só evite criar um eixo para uma ação única — o valor da etiqueta está em
juntar coisas parecidas.

---

## 4. Nome do arquivo

```
acoes/AAAA-MM-descricao-curta.qmd
```

Exemplos que já existem:

```
acoes/2026-03-treinamento-notebooklm-medicina.qmd
acoes/2026-05-projeto-mentoria-enamed.qmd
```

Regras: só minúsculas, sem acentos, sem espaços (use hífen), começando pelo
ano e mês. O prefixo de data mantém a pasta em ordem cronológica.

---

## 5. Nome das fotos

```
fotos/descricao-do-que-aparece.jpg
```

Sem acentos, sem espaços, minúsculas. Um nome descritivo
(`roda-de-conversa-avaliacao.jpg`) vale muito mais que `IMG_4821.jpg` daqui
a um ano.

---

## 6. Campos de números (opcionais)

O Painel soma sozinho o que estiver preenchido. Deixar vazio (`~`) não
quebra nada — a ação simplesmente não entra naquela conta.

| Campo | O que é | Exemplo |
|---|---|---|
| `participantes:` | quantas pessoas participaram | `22` |
| `horas:` | carga horária da ação | `4` |
| `publico:` | quem era o público | `Docentes` |
| `campus:` | unidade onde aconteceu | `Conselheiro Lafaiete` |
| `cursos:` | cursos alcançados | `["Medicina"]` |

Para `publico:`, procure reaproveitar termos já usados —
`Docentes`, `Preceptores`, `Estudantes`, `Coordenadores`,
`Colaboradores administrativos` — pelo mesmo motivo das etiquetas: texto
exato agrupa, texto variado dispersa.
