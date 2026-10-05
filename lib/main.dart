import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'services/ai_service.dart';
void main() {
  runApp(const GelatteIA());
}

class GelatteIA extends StatelessWidget {
  const GelatteIA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gelatte IA',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C4AB6),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

/* ============================================================
   MODELOS
============================================================ */

class Venda {
  final String produto;
  final double valor;
  final DateTime data;

  Venda({
    required this.produto,
    required this.valor,
    required this.data,
  });
}

class Despesa {
  final String descricao;
  final double valor;
  final DateTime data;

  Despesa({
    required this.descricao,
    required this.valor,
    required this.data,
  });
}

/* ============================================================
   LOGIN
============================================================ */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool mostrarSenha = false;

  void entrar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const SizedBox(height: 35),

                // LOGO
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4AB6),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Icon(
                    Icons.ac_unit_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'GELATTE IA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Análise financeira inteligente',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 45),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: senhaController,
                  obscureText: !mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        mostrarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarSenha = !mostrarSenha;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: entrar,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4AB6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Sistema demonstrativo - Projeto Integrado',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   HOME
============================================================ */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaAtual = 0;

  @override
void initState() {
  super.initState();
  carregarVendasDoBanco();
}

Future<void> carregarVendasDoBanco() async {
  final dados = await DatabaseHelper.instance.buscarVendas();

  if (!mounted) return;

  setState(() {
    vendas.clear();

    for (final item in dados) {
      vendas.add(
        Venda(
          produto: item['produto'] as String,
          valor: (item['valor'] as num).toDouble(),
          data: DateTime.parse(item['data'] as String),
        ),
      );
    }
  });
}

  final List<Venda> vendas = [
    Venda(
      produto: 'Sorvete de Chocolate',
      valor: 850,
      data: DateTime.now(),
    ),
    Venda(
      produto: 'Açaí 300ml',
      valor: 620,
      data: DateTime.now(),
    ),
    Venda(
      produto: 'Lanche Natural',
      valor: 430,
      data: DateTime.now(),
    ),
  ];

  final List<Despesa> despesas = [
    Despesa(
      descricao: 'Compra de ingredientes',
      valor: 450,
      data: DateTime.now(),
    ),
    Despesa(
      descricao: 'Energia elétrica',
      valor: 280,
      data: DateTime.now(),
    ),
    Despesa(
      descricao: 'Embalagens',
      valor: 150,
      data: DateTime.now(),
    ),
  ];

  double get receita {
    return vendas.fold(
      0,
      (total, venda) => total + venda.valor,
    );
  }

  double get totalDespesas {
    return despesas.fold(
      0,
      (total, despesa) => total + despesa.valor,
    );
  }

  double get lucro {
    return receita - totalDespesas;
  }

  double get margem {
    if (receita == 0) return 0;
    return (lucro / receita) * 100;
  }

  void adicionarVenda(String produto, double valor) {
    setState(() {
      vendas.add(
        Venda(
          produto: produto,
          valor: valor,
          data: DateTime.now(),
        ),
      );
    });
  }

  void adicionarDespesa(String descricao, double valor) {
    setState(() {
      despesas.add(
        Despesa(
          descricao: descricao,
          valor: valor,
          data: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      DashboardScreen(
        receita: receita,
        despesas: totalDespesas,
        lucro: lucro,
        margem: margem,
        vendas: vendas,
      ),
      VendasScreen(
        vendas: vendas,
        onAdicionar: adicionarVenda,
      ),
      DespesasScreen(
        despesas: despesas,
        onAdicionar: adicionarDespesa,
      ),
      AnaliseScreen(
        receita: receita,
        despesas: totalDespesas,
        lucro: lucro,
        margem: margem,
      ),
    ];

    return Scaffold(
      body: paginas[paginaAtual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Vendas',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Despesas',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'IA',
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   DASHBOARD
============================================================ */

class DashboardScreen extends StatelessWidget {
  final double receita;
  final double despesas;
  final double lucro;
  final double margem;
  final List<Venda> vendas;

  const DashboardScreen({
    super.key,
    required this.receita,
    required this.despesas,
    required this.lucro,
    required this.margem,
    required this.vendas,
  });

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Gelatte! 👋',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Visão financeira',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: const Color(0xFFE9E0F8),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF6C4AB6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C4AB6),
                    Color(0xFF8C67D1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lucro líquido',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dinheiro(lucro),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${margem.toStringAsFixed(1)}% de margem',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    titulo: 'Receitas',
                    valor: dinheiro(receita),
                    icone: Icons.arrow_upward,
                    iconeCor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    titulo: 'Despesas',
                    valor: dinheiro(despesas),
                    icone: Icons.arrow_downward,
                    iconeCor: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Resumo das vendas',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...vendas.reversed.take(3).map(
                  (venda) => Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEDE6F8),
                        child: const Icon(
                          Icons.icecream_outlined,
                          color: Color(0xFF6C4AB6),
                        ),
                      ),
                      title: Text(
                        venda.produto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('Venda registrada'),
                      trailing: Text(
                        dinheiro(venda.valor),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEAF9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF6C4AB6),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A IA pode analisar seus resultados e apontar possíveis pontos de atenção.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color iconeCor;

  const _InfoCard({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.iconeCor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: iconeCor.withValues(alpha: 0.12),
            child: Icon(
              icone,
              color: iconeCor,
              size: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   VENDAS
============================================================ */

class VendasScreen extends StatefulWidget {
  final List<Venda> vendas;
  final Function(String, double) onAdicionar;

  const VendasScreen({
    super.key,
    required this.vendas,
    required this.onAdicionar,
  });

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  final produtoController = TextEditingController();
  final valorController = TextEditingController();

  Future<void> cadastrar() async { 
    final produto = produtoController.text.trim();
    final valor = double.tryParse(
      valorController.text.replaceAll(',', '.'),
    );

    if (produto.isEmpty || valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os dados corretamente.'),
        ),
      );
      return;
    }

    widget.onAdicionar(produto, valor);
    await DatabaseHelper.instance.inserirVenda(
  produto: produto,
  valor: valor,
);

    produtoController.clear();
    valorController.clear();

    Navigator.pop(context);
  }

  void abrirCadastro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova venda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: produtoController,
                decoration: const InputDecoration(
                  labelText: 'Produto',
                  prefixIcon: Icon(Icons.icecream_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: cadastrar,
                  child: const Text('Cadastrar venda'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Nova venda'),
      ),
      body: widget.vendas.isEmpty
          ? const Center(
              child: Text('Nenhuma venda cadastrada.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.vendas.length,
              itemBuilder: (context, index) {
                final venda = widget.vendas.reversed.toList()[index];

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8F5E9),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      venda.produto,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Venda registrada hoje'),
                    trailing: Text(
                      dinheiro(venda.valor),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* ============================================================
   DESPESAS
============================================================ */

class DespesasScreen extends StatefulWidget {
  final List<Despesa> despesas;
  final Function(String, double) onAdicionar;

  const DespesasScreen({
    super.key,
    required this.despesas,
    required this.onAdicionar,
  });

  @override
  State<DespesasScreen> createState() => _DespesasScreenState();
}

class _DespesasScreenState extends State<DespesasScreen> {
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();

  Future<void> cadastrar() async {
  final descricao = descricaoController.text.trim();
  final valor = double.tryParse(
    valorController.text.replaceAll(',', '.'),
  );

  if (descricao.isEmpty || valor == null || valor <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preencha os dados corretamente.'),
      ),
    );
    return;
  }

  widget.onAdicionar(descricao, valor);

  await DatabaseHelper.instance.inserirDespesa(
    descricao: descricao,
    categoria: 'Geral',
    valor: valor,
  );

  descricaoController.clear();
  valorController.clear();

  if (!mounted) return;

  Navigator.pop(context);
}

  void abrirCadastro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova despesa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: cadastrar,
                  child: const Text('Cadastrar despesa'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Nova despesa'),
      ),
      body: widget.despesas.isEmpty
          ? const Center(
              child: Text('Nenhuma despesa cadastrada.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.despesas.length,
              itemBuilder: (context, index) {
                final despesa =
                    widget.despesas.reversed.toList()[index];

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFEBEE),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      despesa.descricao,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('Despesa registrada hoje'),
                    trailing: Text(
                      dinheiro(despesa.valor),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* ============================================================
   ANÁLISE COM IA
============================================================ */

class AnaliseScreen extends StatelessWidget {
  final double receita;
  final double despesas;
  final double lucro;
  final double margem;

  const AnaliseScreen({
    super.key,
    required this.receita,
    required this.despesas,
    required this.lucro,
    required this.margem,
  });

  String dinheiro(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String gerarAnalise() {
    if (lucro <= 0) {
      return 'Os resultados indicam que as despesas estão comprometendo o resultado financeiro. Recomenda-se analisar os principais custos e identificar oportunidades de redução.';
    }

    if (margem < 20) {
      return 'A empresa apresenta resultado positivo, porém a margem de lucro está relativamente baixa. Vale analisar os custos operacionais e a formação dos preços.';
    }

    if (margem < 40) {
      return 'Os indicadores apresentam um resultado positivo. A margem permite identificar uma situação financeira favorável, mas ainda existem oportunidades para melhorar a eficiência dos custos.';
    }

    return 'Os indicadores apresentam uma margem positiva. A análise sugere acompanhar as despesas e manter o controle das vendas para preservar o desempenho financeiro.';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Análise com IA',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Inteligência para apoiar suas decisões financeiras.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: Color(0xFF6C4AB6),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Análise inteligente',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'A IA interpreta os indicadores financeiros e apresenta pontos de atenção para auxiliar a gestão.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Indicadores enviados para análise',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _Indicador(
              titulo: 'Receita',
              valor: dinheiro(receita),
              icone: Icons.arrow_upward,
            ),

            _Indicador(
              titulo: 'Despesas',
              valor: dinheiro(despesas),
              icone: Icons.arrow_downward,
            ),

            _Indicador(
              titulo: 'Lucro',
              valor: dinheiro(lucro),
              icone: Icons.attach_money,
            ),

            _Indicador(
              titulo: 'Margem',
              valor: '${margem.toStringAsFixed(1)}%',
              icone: Icons.percent,
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        color: Color(0xFF6C4AB6),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Resultado da análise',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<String>(
  future: AiService.analisar(
    receita: receita,
    despesas: despesas,
    lucro: lucro,
    margem: margem,
  ),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Analisando os indicadores com IA...'),
        ],
      );
    }

    if (snapshot.hasError) {
      return Text(
        'Não foi possível gerar a análise com IA.\n${snapshot.error}',
        style: const TextStyle(
          height: 1.5,
          color: Colors.red,
        ),
      );
    }

    return Text(
      snapshot.data ?? 'Nenhuma análise foi retornada.',
      style: const TextStyle(
        height: 1.5,
        color: Colors.black87,
      ),
    );
  },
),
                ],
              ),
            ),

            const SizedBox(height: 15),
            
          ],
        ),
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;

  const _Indicador({
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEDE7F6),
          child: Icon(
            icone,
            color: const Color(0xFF6C4AB6),
          ),
        ),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}