﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦП_ЦифровойПриемВключен.Значение КАК ВключенЦП
		|ИЗ
		|	Константа.ЦП_ЦифровойПриемВключен КАК ЦП_ЦифровойПриемВключен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий()
			И НЕ ВыборкаДетальныеЗаписи.ВключенЦП Тогда
		Отказ = Истина;
		Сообщить(НСтр("ru = 'Цифровой прием не включен в настройках системы.'"), СтатусСообщения.ОченьВажное);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДокументыПриемаПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ХранилищеСистемныхНастроек.Сохранить("СоставДокументовЦП", "Изменение", Истина); 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПризнакИзмененияДокументовЦП(КлючОбъекта, КлючНастроек)
	
	Значение = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, КлючНастроек);
	
	Если Значение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьПризнакИзмененияДокументовЦП(КлючОбъекта, КлючНастроек, Значение)
	
	ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, КлючНастроек, Значение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОтборПоСтатусу(ИмяСтатусаОтбора)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ВидСравнения", ВидСравненияКомпоновкиДанных.Равно);
	
	Если ИмяСтатусаОтбора = "ГруппаФормированиеПФ" Тогда
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.Сформирован);
	ИначеЕсли ИмяСтатусаОтбора = "ГруппаПодписаниеПФ" Тогда
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.ПФ_Сформированы);
	ИначеЕсли ИмяСтатусаОтбора = "ГруппаПередачаНаПРР" Тогда
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.ПФ_ПодписаныОрганизацией);
	ИначеЕсли ИмяСтатусаОтбора = "ГруппаПодписаниеКандидатом" Тогда
		ПараметрыОтбора.Вставить("ВидСравнения", ВидСравненияКомпоновкиДанных.ВСписке);
		
		ЗначениеОтбора = Новый СписокЗначений;
		ЗначениеОтбора.Добавить(Перечисления.ЦП_СтатусыЦП.ПФ_ПереданыНаПРР);
		ЗначениеОтбора.Добавить(Перечисления.ЦП_СтатусыЦП.ПФ_ПереданыСотрудникуПРР);
		
		ПараметрыОтбора.Вставить("ЗначениеОтбора", ЗначениеОтбора);
	ИначеЕсли ИмяСтатусаОтбора = "ГруппаЗавершениеПриема" Тогда
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.ПФ_ПодписаныСотрудникомПРР);
	ИначеЕсли ИмяСтатусаОтбора = "ГруппаЗавершено" Тогда
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.Завершен);
	Иначе
		ПараметрыОтбора.Вставить("ЗначениеОтбора", Перечисления.ЦП_СтатусыЦП.ПустаяСсылка());
	КонецЕсли;
	
	Возврат ПараметрыОтбора;
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовкиЭтаповНаСервере()
	СтраницыЭтапов = Элементы.ГруппаЭтапыОбработки.ПодчиненныеЭлементы;
	
	Для каждого СтраницаЭтапа Из СтраницыЭтапов Цикл
		
		ПозицияКолДок = СтрНайти(СтраницаЭтапа.Заголовок, " (");
		
		Если ПозицияКолДок > 0 Тогда
			СтраницаЭтапа.Заголовок = Лев(СтраницаЭтапа.Заголовок, ПозицияКолДок - 1);
		КонецЕсли;
	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ЦП_Сервер.ПолучитьСтатусыДокументовЦП_ВТ();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.Сформирован)
		|			ТОГДА ""ГруппаФормированиеПФ""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_Сформированы)
		|			ТОГДА ""ГруппаПодписаниеПФ""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПодписаныОрганизацией)
		|			ТОГДА ""ГруппаПередачаНаПРР""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПереданыНаПРР)
		|				ИЛИ ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПереданыСотрудникуПРР)
		|			ТОГДА ""ГруппаПодписаниеКандидатом""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПодписаныСотрудникомПРР)
		|			ТОГДА ""ГруппаЗавершениеПриема""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.Завершен)
		|			ТОГДА ""ГруппаЗавершено""
		|		ИНАЧЕ ""ГруппаНеВСоставеЦП""
		|	КОНЕЦ КАК Статус,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаДокументовПолная.ДокументПриема) КАК КолДок
		|ИЗ
		|	ТаблицаДокументовПолная КАК ТаблицаДокументовПолная
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.Сформирован)
		|			ТОГДА ""ГруппаФормированиеПФ""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_Сформированы)
		|			ТОГДА ""ГруппаПодписаниеПФ""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПодписаныОрганизацией)
		|			ТОГДА ""ГруппаПередачаНаПРР""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПереданыНаПРР)
		|				ИЛИ ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПереданыСотрудникуПРР)
		|			ТОГДА ""ГруппаПодписаниеКандидатом""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.ПФ_ПодписаныСотрудникомПРР)
		|			ТОГДА ""ГруппаЗавершениеПриема""
		|		КОГДА ТаблицаДокументовПолная.Статус = ЗНАЧЕНИЕ(Перечисление.ЦП_СтатусыЦП.Завершен)
		|			ТОГДА ""ГруппаЗавершено""
		|		ИНАЧЕ ""ГруппаНеВСоставеЦП""
		|	КОНЕЦ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтраницаЭтапа = Элементы[ВыборкаДетальныеЗаписи.Статус];
		
		КолДок = СтрЗаменить(СтрЗаменить(Строка(ВыборкаДетальныеЗаписи.КолДок), Символы.НПП, ""), " ", "");
		
		СтраницаЭтапа.Заголовок = СтраницаЭтапа.Заголовок + " (" + КолДок + ")";
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьДокументВСоставЦП(Команда)
	ВыполнитьДействиеЦП("ВключитьДокументВСоставЦП");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКомплектПФ(Команда)
	ВыполнитьДействиеЦП("СформироватьКомплектПФ");
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПФ(Команда)
	ВыполнитьДействиеЦП("ПодписатьПФ");
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДокументыНаПРР(Команда)
	ВыполнитьДействиеЦП("ПередатьДокументыНаПРР");
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДокументыНаГосключ(Команда)
	ВыполнитьДействиеЦП("ПередатьДокументыНаГосключ");
КонецПроцедуры

&НаКлиенте
Процедура ПередатьКандидатуСсылкиНаПодписьДокументов(Команда)
	ВыполнитьДействиеЦП("ПередатьКандидатуСсылкиНаПодписьДокументов");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодписьКандидата(Команда)
	ВыполнитьДействиеЦП("ПроверитьПодписьКандидата");
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПрием(Команда)
	ВыполнитьДействиеЦП("ЗавершитьПрием");
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПодписанияФайлов(Результат, Контекст) Экспорт	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	ЗаписанныеОбъекты = Контекст.ЗаписанныеОбъекты;

	Если ЗаписанныеОбъекты.Количество() > 0 Тогда
		ОповеститьОбИзменении(ТипЗнч(ЗаписанныеОбъекты[0]));
	КонецЕсли;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиСлужебныйКлиент");
		МодульРаботаСФайламиСлужебныйКлиент.ОповеститьОбИзмененииФайлов(ЗаписанныеОбъекты);
	КонецЕсли;
	ПоказатьОповещениеПользователя(, , НСтр("ru = 'Сохранение и подписание завершено'"), БиблиотекаКартинок.Информация32);
	
	Результат = ЦП_Сервер.ВыполнитьОбработкуДокумента(Контекст.ДокументПриема, Контекст.Статус, Контекст.ДатаСтатуса, Контекст.ДействиеЦП, Контекст.ПараметрыДействия);

	Если Результат.Выполнено Тогда
		ОповеститьОбИзменении(Контекст.ДокументПриема);
		
		Элементы.ДокументыПриема.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЗаписанныеОбъекты(ЗаписанныеОбъекты, ОповещениеЗавершенияПодписания)
	ДополнительныеПараметры = Новый Структура("ОбработкаРезультата", ОповещениеЗавершенияПодписания);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПодписатьФайл(ЗаписанныеОбъекты, УникальныйИдентификатор, ДополнительныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЦП(ДействиеЦП)
	ТекущиеДанные = Элементы.ДокументыПриема.ТекущиеДанные;
	
	ДокументПриема = ТекущиеДанные.ДокументПриема;
	Статус = ТекущиеДанные.Статус;
	ДатаСтатуса = ТекущиеДанные.ДатаСтатуса;
	
	ПараметрыДействия = Новый Структура;
	
	Если ДействиеЦП = "СформироватьКомплектПФ" ИЛИ
			ДействиеЦП = "ПодписатьПФ" ИЛИ
			ДействиеЦП = "ПередатьДокументыНаПРР" ИЛИ
			ДействиеЦП = "ПередатьКандидатуСсылкиНаПодписьДокументов" ИЛИ
			ДействиеЦП = "ПроверитьПодписьКандидата" Тогда
		ПараметрыДействия.Вставить("Комплект", ТекущиеДанные.Комплект);
	КонецЕсли;
	
	Если ДействиеЦП = "ПодписатьПФ" Тогда
		ПараметрыДействия.Вставить("ЭтапОбработки", "Начало");
	КонецЕсли;
	
	Результат = ЦП_Сервер.ВыполнитьОбработкуДокумента(ДокументПриема, Статус, ДатаСтатуса, ДействиеЦП, ПараметрыДействия);
	
	Если Результат.Выполнено Тогда
		Если ДействиеЦП = "ПодписатьПФ" Тогда
			ПараметрыДействия.ЭтапОбработки = "Окончание";
			
			Контекст = Новый Структура;
			Контекст.Вставить("ЗаписанныеОбъекты", Результат.ЗаписанныеОбъекты);
			Контекст.Вставить("ДокументПриема", ДокументПриема);
			Контекст.Вставить("Статус", Статус);
			Контекст.Вставить("ДатаСтатуса", ДатаСтатуса);
			Контекст.Вставить("ДействиеЦП", ДействиеЦП);
			Контекст.Вставить("ПараметрыДействия", ПараметрыДействия);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеПодписанияФайлов", ЭтотОбъект, Контекст);
			ПодписатьЗаписанныеОбъекты(Результат.ЗаписанныеОбъекты, ОписаниеОповещения);
		Иначе
			ОповеститьОбИзменении(ДокументПриема);
			
			Элементы.ДокументыПриема.Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьКолонки(ИменаКолонок, Видимость)
	
	МассивИменКолонок = СтрРазделить(ИменаКолонок, ",", Ложь);
	
	Для каждого ИмяКолонки Из МассивИменКолонок Цикл
	
		Элементы["ДокументыПриема" + ИмяКолонки].Видимость = Видимость;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриемаПриАктивизацииСтроки(Элемент)
	
	ВсеСкрываемыеКолонки = "Статус,ДатаСтатуса,Состояние,Комплект";
	
	ПоказатьСкрытьКолонки(ВсеСкрываемыеКолонки, Истина);
	
	ИмяЗакладки = Элементы.ГруппаЭтапыОбработки.ТекущаяСтраница.Имя;
	
	СкрываемыеКолонки = "";
	
	Если ИмяЗакладки = "ГруппаФормированиеПФ" Тогда
	ИначеЕсли ИмяЗакладки = "ГруппаПодписаниеПФ" Тогда
	ИначеЕсли ИмяЗакладки = "ГруппаПередачаНаПРР" Тогда
	ИначеЕсли ИмяЗакладки = "ГруппаПодписаниеКандидатом" Тогда
	ИначеЕсли ИмяЗакладки = "ГруппаЗавершениеПриема" Тогда
	ИначеЕсли ИмяЗакладки = "ГруппаНеВСоставеЦП" Тогда
		
		СкрываемыеКолонки = "Состояние,Комплект";
		
	ИначеЕсли ИмяЗакладки = "ГруппаЗавершено" Тогда
		
		СкрываемыеКолонки = "Состояние";
		
	КонецЕсли;
	
	ПоказатьСкрытьКолонки(СкрываемыеКолонки, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриемаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ДокументыПриемаДокументПриема" Тогда
		ОткрытьФорму("Документ.ПриемНаРаботу.ФормаОбъекта", Новый Структура("Ключ", ВыбраннаяСтрока));
	ИначеЕсли Поле.Имя = "ДокументыПриемаСотрудник" Тогда
		ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.Сотрудник));
	ИначеЕсли Поле.Имя = "ДокументыПриемаКомплект" Тогда
		Если Строка(Элемент.ТекущиеДанные.Статус) = "Печатные формы. Сформированы." Тогда
			МассивПараметров = Новый Массив;
			МассивПараметров.Добавить(Новый Структура("ДокументПриема", Элемент.ТекущиеДанные.ДокументПриема));
			
			КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.ЦП_КомплектыДокументовПриема", МассивПараметров);
			
			ОткрытьФорму("РегистрСведений.ЦП_КомплектыДокументовПриема.ФормаЗаписи", Новый Структура("Ключ", КлючЗаписи));
		ИначеЕсли ЗначениеЗаполнено(Элемент.ТекущиеДанные.Статус) Тогда
			ОткрытьФорму("Справочник.ЦП_КомплектыДокументов.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.Комплект));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГруппаЭтапыОбработкиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ПараметрыОтбора = ПолучитьОтборПоСтатусу(ТекущаяСтраница.Имя);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыПриема, "Статус", ПараметрыОтбора.ЗначениеОтбора, ПараметрыОтбора.ВидСравнения, "ОтборПоСтатусу");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ГруппаЭтапыОбработкиПриСменеСтраницы(Элементы.ГруппаЭтапыОбработки, Элементы.ГруппаЭтапыОбработки.ТекущаяСтраница);
	
	ПодключитьОбработчикОжидания("ОбновитьЗаголовкиЭтапов", 1, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовкиЭтапов()
	
	Если ПрочитатьПризнакИзмененияДокументовЦП("СоставДокументовЦП", "Изменение") Тогда
		
		ЗаписатьПризнакИзмененияДокументовЦП("СоставДокументовЦП", "Изменение", Ложь);
		
		ОбновитьЗаголовкиЭтаповНаСервере();
	КонецЕсли;
	
КонецПроцедуры
