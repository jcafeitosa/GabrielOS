# Provas técnicas — plano (proposta)

Status: proposta. Nenhuma prova foi executada. Responsáveis e prazos ainda não foram designados.

Regra geral: cada prova entrega evidência verificável (teste automatizado, log, medição ou relatório). Sem evidência, a prova não está concluída.

## P1 — Sincronização desktop–plataforma

Pergunta: o desktop mantém eventos operacionais sem perda nem duplicidade quando a conexão cai?

Teste:
- Gerar eventos offline, reconectar e verificar entrega única.
- Repetir a mesma mensagem e confirmar que não há efeito duplicado.
- Medir atraso entre evento local e persistência na plataforma.

Aceite: zero perda e zero duplicidade em lote de teste definido; atraso medido e documentado.

## P2 — MT5 via bridge

Pergunta: a bridge informa com segurança o estado de uma ordem, inclusive após timeout?

Teste:
- Enviar ordem em conta demo e forçar timeout na resposta.
- Consultar o estado na corretora antes de qualquer reenvio.
- Verificar posições e saldos após reconexão.

Aceite: nenhum reenvio sem consulta prévia; estado final conferido na conta demo.

## P3 — CCXT nas exchanges escolhidas

Pergunta: as chaves funcionam com permissões mínimas, e a consulta de estado após timeout é confiável?

Teste:
- Criar chave somente com leitura e chave de trading, sem saque.
- Confirmar que a chave de trading não consegue sacar.
- Repetir o teste de timeout da P2 na exchange.

Aceite: permissões verificadas; saque bloqueado; consulta de estado usada antes de reenvio.

Ajuste (decisão registrada): na Binance Testnet não é possível desabilitar a permissão de saque de chaves de teste, e o FAQ da Testnet informa que os saldos são virtuais e não saem do ambiente. Por isso, na Testnet, o critério de saque vira: registrar `canWithdraw: True` como limitação do ambiente, sem valor financeiro real em risco. A verificação de saque bloqueado precisa ser refeita em conta real, com chave somente leitura e de trading sem saque, antes de qualquer uso com dinheiro. Essa parte fica pendente e não está aprovada.

## P4 — Recuperação de eventos e projeções

Pergunta: as projeções podem ser reconstruídas a partir do EventStoreDB, e o atraso fica visível?

Teste:
- Apagar uma projeção de teste e reconstruí-la.
- Comparar o resultado com a projeção anterior.
- Medir o atraso durante carga definida.

Aceite: projeção reconstruída igual à anterior; atraso exibido e medido.

## P5 — Restauração de backup

Pergunta: PostgreSQL e EventStoreDB podem ser restaurados dentro do objetivo de tempo e de perda definido?

Teste:
- Restaurar backup em ambiente isolado.
- Validar integridade e contagem de registros.
- Medir o tempo total de restauração.

Aceite: restauração concluída; valores de RTO e RPO medidos e comparados com a meta aprovada. Meta ainda não definida.

## P6 — Isolamento entre agências

Pergunta: uma agência consegue acessar dados de outra por consulta, API, arquivo, evento, fila, cache ou canal?

Teste:
- Criar duas agências de teste e tentar acesso cruzado em cada uma das superfícies listadas.
- Verificar que as negativas aparecem na auditoria.

Aceite: nenhum acesso cruzado bem-sucedido; todas as negativas registradas.

## Ordem sugerida

P6 e P3 primeiro, por riscos de segurança e de dinheiro. Depois P2, P1, P4 e P5.

## Pendências antes de iniciar

- Designar responsável técnico por prova.
- Definir o ambiente de teste (demo para MT5 e exchanges, contas de teste sem dinheiro real).
- Definir metas de RTO e RPO.
