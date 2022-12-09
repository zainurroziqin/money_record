import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_aset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/cHome.dart';
import 'package:money_record/presentation/controller/cUser.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';
import 'package:money_record/presentation/page/history/add_history.dart';
import 'package:money_record/presentation/page/history/income_outcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawer(),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
                child: Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hi,',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Obx(() {
                            return Text(
                              cUser.data.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Builder(builder: (ctx) {
                      return Material(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColor.chart,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                              onTap: () {
                                Scaffold.of(ctx).openEndDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                color: AppColor.primary,
                              )),
                        ),
                      );
                    })
                  ],
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async{
                      cHome.getAnalysis(cUser.data.idUser!);
                    },
                    child: ListView(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                                  children: [
                    Text(
                      'Pengeluaran Hari Ini',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.spaceHeight(),
                    cardToday(context),
                    DView.spaceHeight(30),
                    Center(
                      child: Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    DView.spaceHeight(30),
                    Text(
                      'Pengeluaran Minggu Ini',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    weekly(),
                    DView.spaceHeight(),
                    Text(
                      'Perbandingan Bulan Ini',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.spaceHeight(24),
                    monthly(context),
                                  ],
                                ),
                  ))
            ],
          ),
        ));
  }

  Drawer drawer() {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 0),
              padding: EdgeInsets.fromLTRB(20, 16, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAsset.profile),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                cUser.data.name ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              );
                            }),
                            Obx(() {
                              return Text(
                                cUser.data.email ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        Session.clearUser();
                        Get.off(() => const LoginPage());
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => AddHistoryPage())?.then((value){
                  if(value??false){
                    cHome.getAnalysis(cUser.data.idUser!);
                  }
                });
              },
              leading: const Icon(Icons.add),
              horizontalTitleGap: 0,
              title: const Text('Tambah Baru'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {
                Get.to(() => const IncomeOutcomePage(type: 'Pemasukan',));
              },
              leading: const Icon(Icons.south_west),
              horizontalTitleGap: 0,
              title: const Text('Pemasukan'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {
                Get.to(() => const IncomeOutcomePage(type: 'Pengeluaran',));
              },
              leading: const Icon(Icons.north_east),
              horizontalTitleGap: 0,
              title: const Text('Pengeluaran'),
              trailing: const Icon(Icons.navigate_next),
            ),
            const Divider(height: 1),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.history),
              horizontalTitleGap: 0,
              title: const Text('Riwayat'),
              trailing: const Icon(Icons.navigate_next),
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            children: [
              Obx(() {
                return DChartPie(
                  data: [
                    {'domain': 'Income', 'measure': cHome.monthIncome},
                    {'domain': 'Outcome', 'measure': cHome.monthOutcome},
                    if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                      {'domain': 'nol', 'measure': 1}
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case 'Income':
                        return AppColor.primary;
                      case 'Outcome':
                        return AppColor.chart;
                      default:
                        return AppColor.bg.withOpacity(0.5);
                    }
                  },
                  donutWidth: 20,
                  labelColor: Colors.transparent,
                  showLabelLine: false,
                );
              }),
              Center(child: Obx(() {
                return Text(
                  '${cHome.percentIncome}%',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: AppColor.primary),
                );
              }))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.primary,
                ),
                DView.spaceWidth(8),
                const Text('Pemasukan')
              ],
            ),
            DView.spaceHeight(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.chart,
                ),
                DView.spaceWidth(8),
                const Text('Pengeluaran')
              ],
            ),
            DView.spaceHeight(20),
            Obx(
              () {
                return Text(cHome.monthPercent);
              }
            ),
            DView.spaceHeight(10),
            Text('atau setara'),
            Text(
              AppFormat.currency(cHome.differentMonth.toString()),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary),
            )
          ],
        )
      ],
    );
  }

  AspectRatio weekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() {
        return DChartBar(
          data: [
            {
              'id': 'Bar',
              'data': List.generate(7, (index) {
                return {
                  'domain': cHome.weekText()[index],
                  'measure': cHome.week[index]
                };
              })
            },
          ],
          domainLabelPaddingToAxisLine: 8,
          axisLineTick: 2,
          axisLineColor: AppColor.primary,
          measureLabelPaddingToAxisLine: 16,
          barColor: (barData, index, id) => AppColor.primary,
          showBarValue: true,
        );
      }),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return Text(
                AppFormat.currency(cHome.today.toString()),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold, color: AppColor.secondary),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(() {
              return Text(
                cHome.todayPercent,
                style: const TextStyle(color: AppColor.bg, fontSize: 16),
              );
            }),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Selengkapnya',
                  style: TextStyle(color: AppColor.primary),
                ),
                Icon(
                  Icons.navigate_next,
                  color: AppColor.primary,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
