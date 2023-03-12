import 'package:flutter/material.dart';
import 'package:lang_log_b/main.dart';
import 'package:lang_log_b/screens/Common/buttons.dart';
import 'package:lang_log_b/screens/Common/texts.dart';
import 'package:lang_log_b/screens/test_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Html(
data: """
        <div>
          <h1>This is Title</h1>
          <p>This is Regular text</p>
          <h3>Text Styles</h3>
          <ul>
            <li><i>This is Italic text</i></li>
            <li><b>This is Bold text</b></li>
            <li><u>This is Underline text</u></li>
            <li><em>This is Emphasized text</em></li>
            <li><mark>This is Marked text</mark></li>
          </ul>
          <!--You can pretty much put any html in here!-->
        </div>
      """,
)
*/

class InstructionPage extends StatelessWidget {
  InstructionPage({Key key}) : super(key: key);

  DateTime _now;

  int _difference() {
    final date2 = DateTime.now();
    return date2.difference(_now).inSeconds;
  }

  void setFirstStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSecondStart', true);
  }

  Widget _topPanel(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 15, right: 0),
          child: Image.asset("assets/backgrounds/toppanel-background.png",
              fit: BoxFit.fill)),
      Container(
        padding: EdgeInsets.only(top: 3, left: 20, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 0),
                  height: 65,
                  width: 65,
                  child: TextButton(
                    child: Image.asset(
                        "assets/buttons/home-button-blue.png",
                        fit: BoxFit.fill),
                    onPressed: () {
                      // LangLogBApp.analytics.logEvent(name: 'Инструкция_КнопкаДомой', parameters: { 'duration': _difference() });
                      Navigator.of(context).pushReplacementNamed('/home');
                      // Navigator.popUntil(
                      //     context, ModalRoute.withName('/'));
                    },
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 5.0, right: 75.0),
                alignment: Alignment.center,
                child: LLTopBarButton(
                    text: 'ЛОГИЧЕСКИЙ КОНТЕКСТ',
                    titleColor: const Color(0xffffffff),
                    backgroundColor:
                    const Color.fromRGBO(227, 29, 29, 1),
                    onPressed: () {
                      // LangLogBApp.analytics.logEvent(name: 'Инструкция_КнопкаКонтекст', parameters: { 'duration': _difference() });
                      Navigator.of(context)
                          .pushReplacementNamed('/systems');
                    }),
              ),
            )
          ],
        ),
      )
    ]);
  }

  int duration() {

  }

  @override
  Widget build(BuildContext context) {
    setFirstStart();

    _now = new DateTime.now();

    return Material(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backgrounds/main-background.png'),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          SizedBox(height: 25),
          _topPanel(context),
          LLTitleText(
            first: 'И',
            second: 'НСТРУКЦИЯ',
            alignment: Alignment.center,
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width - 46,
              padding: EdgeInsets.only(left: 0, right: 0, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3302589f),
                    spreadRadius: 2,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
                child: SingleChildScrollView(
                  child: Text(
                      """ВНИМАНИЕ. Авторизация (покупка) открывает доступ на 73 дня, причём раздел Производные открывается после выполнения тестов на 20 страницах подраздела Система раздела Логический контекст.
                      
С помощью LangLogB человек в возрасте 13-60 лет за 31 день решает проблему автоматического овладения английским языком, даже начиная с уровня «ноль». Фонетическая и тестовая части приложения чрезвычайно полезны для всех детей в возрасте до 13 лет.

После использования LangLogB Вы знаете более 2700 главных английских слов, правила образования частей речи, множественного числа, степеней сравнения прилагательных, имеете хорошее или отличное произношение и правописание и, главное, умноженную силу памяти. Этот результат обеспечивает автоматическое, без усилий овладение разговорной речью после ещё 10-15 занятий с носителем языка, лучше всего учителем.

Единственной причиной неудачи в овладении иностранным языком является недостаточное знание главных слов. Если в результате выполнения Начального Теста Вы не знаете 2-6 слов из 20, то необходимо выполнить только тесты для коррекции знания главной лексики с темпом 2 страницы в день. Если же Ваши знания хуже, то следует пройти полный курс LangLogB с темпом 1 страница в день. Только LangLogB обеспечивает примерно одинаковую частотность логической обработки главных слов, что имеет решающее значение для достижения результата. В LangLogB визуальный логический оператор делает одинаковыми более 62% и полностью уничтожает для восприятия более 52% букв всех главных английских слов. Кроме того, каждый школьник заранее знает более 30% главных слов, которые являются интернациональными или производными. Более того, LangLogB является самым быстрым приложением в мире: любая точка учебного материала достигается всего в два клика.

Тренировка запоминания Логического Контекста LangLogB, - это единственный метод овладения множеством языков и умножения памяти. Детали можно найти на сайте www.langlogb.com.

Авторизация (покупка) открывает доступ на 73 дня, причём раздел Производные открывается после выполнения тестов на 20 страницах подраздела Система раздела Логический контекст.
 
LangLogB предоставляет свободный доступ к трём страницам раздела Логический Контекст. Раздел Производные включает в себя три подраздела: Система, Тесты, Контроль.

Проблема автоматического овладения английским языком, начиная с уровня ”ноль”, решается путём тренировки запоминания учебного материала подраздела Система, который одновременно является рефлексивной морфологической структурой, идеальной корректирующей фонетической системой и коммуникативным семантическим стандартом. Такая тренировка каждой новой страницы начинается с прослушивания фонетической системы.

После нажатия на кнопку Система Вы попадаете на рабочий стол, который содержит 31 кнопку с номерами страниц. Ваше задание заключается в том, чтобы запомнить как можно больше групп слов сначала в части 1, а затем в части 2 страницы 1. После этого, Вы объединяете в своём восприятии обе части страницы. Принцип тренировки LangLogB: запоминание каждой новой страницы сопровождается повторением предыдущих. Обычно логическое запоминание новой страницы выполняется вечером, а повторы утром, после полудня, и вечером после очередной новой страницы.

Чтобы понять как необходимо воспринимать учебный материал, Вы нажимаете кнопку громкоговорителя под кнопкой номера страницы Системы. Программа осуществляет фонетическую установку. Первое воспроизведение группы слов предназначено для прослушивания, а второе воспроизведение даёт Вам возможность повторить слова вслух вместе с программой. На наших занятиях в классе Вы бы делали это обязательно.

Фонетическая установка в форме глубокой аудиовизуальной дифференциации не имеет аналогов в мировой практике. Она обеспечивает не только идеальную коррекцию фонетической функции человека для определённого языка, но и развитие артикуляционного аппарата, что особенно важно в младенческом и детском возрасте.

Мы также настоятельно рекомендуем тренировать запоминание при помощи пальцевой моторики просто переписывая страницы групп английских слов на листочки или в тетрадь. Это важно для установки отличного правописания, а кроме того, Вы получите визуальный доступ ко всей странице целиком помимо секции фонетика в приложении.

В подразделе Тесты нажатие на кнопку номера страницы запускает тест для всей страницы, и Вы следуете инструкциям на экране. Все неправильные ответы программа записывает в тренинг-файл, который обозначен в виде шапки под номером страницы. Каждое новое тестирование страницы формирует новый тренинг-файл, но только после Авторизации.

Таким образом, первоначальное запоминание выполняется в направлении от английского слова к значению слова на родном языке, а тестирование, - наоборот. Тренинг-файлы позволяют сосредоточить Ваше внимание на первоначальных ошибках и экономят время без необходимости проведения повторного тестирования по мере продвижения по страницам подраздела Система.

В подразделе Примеры, особенно для больших групп, предложения специально подогнаны, приспособлены для демонстрации разных значений английских слов. Но во всех случаях они вполне адекватно соответствуют гипотетическому контексту ситуации. Иными словами, их употребление в реальном разговоре позволит слушателю правильно понять сказанное.

После логической обработки каждых 5-ти страниц, Вам следует выполнить контрольную работу. Подраздел Контроль содержит 6 кнопок, которые аналогичны подразделу Тесты. Отличие состоит в содержании теста, который включает в себя наиболее сложные для запоминания 46 английских слов с каждых 5-ти страниц Системы.

Овладение первой страницей создаёт дополнительный объём памяти для усвоения второй страницы, и так далее до последней страницы второго раздела Производные. В итоге, помимо английского языка, Вы получаете умноженную память, которой бесплатно пользуетесь всю жизнь.
""",
                      style: const TextStyle(
                          color: const Color(0xff092330),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.justify),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 220,
            height: 33,
            child: LLButton(
                text: 'ПРОЙТИ НАЧАЛЬНЫЙ ТЕСТ',
                titleColor: const Color(0xffffffff),
                backgroundColor: const Color(0xff4fafff),
                onPressed: () {
                  // LangLogBApp.analytics.logEvent(name: 'Инструкция_КнопкаНачальныйТест', parameters: { 'duration': _difference() });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TestPage(
                            isPassed: true,
                            testId: 0,
                          )));
                }),
          ),
          SizedBox(height: 25),
        ],
      ),
    ));
  }
}
