# Desenho da plataforma — consolidado (proposta)

Status: proposta para validação. Nada aqui está aprovado para construção até cumprir os critérios de entrada da fase de provas técnicas.

## 1. Escopo

Plataforma com agências, agentes de IA hierárquicos, fork com rebrand do OpenBot para desktop, Bank (livro financeiro, saldo pré-pago, MMN e saques) e integrações com MT5, exchanges via CCXT, carteiras, Stripe e dados de mercado.

## 2. Fundação (módulos)

| Módulo | Proposta central |
|---|---|
| Identidade e permissões | Dono humano único por agência; usuários internos por departamento; agentes com identidade própria. Permissões verificadas pelo nosso sistema, não só pelo cargo. |
| Agências e tenancy | Criação em etapas idempotentes; limite de cinco indicados diretos; isolamento verificado em consultas, APIs, arquivos, eventos, filas, cache e canais. |
| Gestão de agentes | Hierarquia C → B → A → especialistas → workers; ciclo criado, configurado, ativo, pausado, suspenso, encerrado. |
| Políticas e aprovações | Regras versionadas; decisão permite, pede aprovação ou bloqueia; controle mais restritivo prevalece. |
| Eventos e mensageria | EventStoreDB/KurrentDB como fonte de eventos; PostgreSQL para projeções; BullMQ + Redis; WebSockets; gRPC quando justificado. |
| Observabilidade e auditoria | OpenTelemetry; auditoria inclui negações; backup só vale após teste de recuperação. |
| Integrações e segredos | Credenciais por agência, permissões mínimas, saque pela exchange desabilitado por padrão; sem frases de recuperação ou chaves privadas. |
| Configurações, arquivos, notificações, planos | Hierarquia de limites; armazenamento compatível com S3 (a validar); planos Free, Trader, Trader+, Ultra com direitos efetivos. |

## 3. Departamentos

| Departamento | Escopo |
|---|---|
| Executivo | Painel consolidado, objetivos, riscos e decisões. |
| Comercial e CRM | Funil, indicações, planos e ofertas; avaliar DeskcommCRM. |
| Financeiro | Contas a receber e a pagar, aprovações, conciliação, fechamento. Segregação de funções. |
| Jurídico e Compliance | Termos, KYC/KYB, LGPD, regulatório, contratos, incidentes. |
| Produto e Tecnologia | Backlog, arquitetura, engenharia, releases, feature flags. |
| Operações e Suporte | Atendimento, monitoramento, resposta a incidentes, acesso mínimo. |
| RH e Gestão de Agentes | Colaboradores, acessos, capacidade, registro e revisão periódica de agentes. |
| Marketing e Conteúdo | Campanhas e conteúdo com revisão de compliance; sem promessa de ganho. |
| Dados e Analytics | Dicionário de dados, eventos, qualidade, governança de acesso. |

## 4. Decisões já tomadas

- Fork com rebrand do OpenBot para desktop.
- Better Auth para contas, sessões, Organization, 2FA e Stripe.
- EventStoreDB/KurrentDB, PostgreSQL, BullMQ + Redis, OpenTelemetry.
- Saque: MFA em todos os pedidos; acima de US$ 100 antes da taxa, aprovação humana do Financeiro; mínimo de US$ 50 antes da taxa.
- Saldo disponível usado primeiro na cobrança; cobrança diária às 00h00 UTC.
- Pagamento cripto pendente: prazo de 24 horas acordado.
- Agente nunca aprova a própria ação financeira.

## 5. Decisões em aberto (dependem de negócio ou jurídico)

- Cotação USD/USDT e fonte de liquidez dos saques.
- Regras de confirmação por rede.
- Tratamento fiscal de taxas, comissões e saques.
- Permissão de cripto, MMN e divulgação de resultados por país.
- Prazos de retenção de dados e documentos.
- Preços trimestrais e limites de cada plano.
- Quem contrata e desliga pessoas e agentes; política de remuneração.
- Provedor de KYC; ferramenta de chamados; ferramenta de BI.

## 6. Critérios de entrada na fase de provas técnicas

1. Sincronização desktop–plataforma sem presumir entrega instantânea, com recuperação após desconexão.
2. MT5 via bridge: ordens, posições e estado de envio incerto.
3. CCXT nas exchanges escolhidas: permissões mínimas e consulta de estado após timeout.
4. Recuperação de eventos e reconstrução de projeções.
5. Teste de restauração de backup do PostgreSQL e do EventStoreDB.
6. Cada prova tem critério de aceite e evidência registrada.

## 7. Riscos principais

- Divergência entre livro financeiro e provedores (cobrança, saque, estorno).
- Envio duplicado de ordem ou saque por resposta incerta.
- Vazamento de credenciais ou dados entre agências.
- Exigências regulatórias de cripto, corretagem e MMN que limitem produtos.
- Dependência de um único provedor de dados ou de IA.

## 8. Próximos passos

1. Validar este consolidado com o dono e com Jurídico.
2. Abrir as provas técnicas da seção 6, com responsável e prazo por prova.
3. Definir estimativa de prazo e custo do MVP por fase.
4. Registrar cada decisão aberta como registro formal com alternativas e consequências.
