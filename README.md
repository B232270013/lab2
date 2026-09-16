# Лаборатори №2 — Гүйцэтгэлийн хэмжүүрийг k6-аар хэмжих

**Хичээл:** F.CSA313 — Программ хангамжийн чанарын баталгаа ба тест  
**Сэдэв:** Гүйцэтгэлийн хэмжүүрийг k6-аар хэмжих  
**Оюутан:** Б. Мөнгөншагай  
**Оюутны код:** B232270013

## 1. Зорилго

k6 ашиглан latency (p90, p95), throughput, error rate болон availability-г хэмжиж, ачаалал нэмэгдэх үед системийн гүйцэтгэл хэрхэн өөрчлөгдөхийг ажиглав. Туршилтад зөвшөөрөгдсөн `https://test.k6.io` practice сайтыг ашигласан.

## 2. Файлын бүтэц

```text
lab2/
├── script.js
├── stages.js
├── threshold-pass.js
├── threshold-fail.js
├── README.md
├── results/
│   ├── run-05vu.txt
│   ├── run-30vu.txt
│   └── run-100vu.txt
└── screenshots/
    ├── run-05vu.png
    ├── run-30vu.png
    ├── run-100vu.png
    ├── threshold-pass.png
    └── threshold-fail.png
```

## 3. k6 хувилбар

Энд өөрийн компьютер дээр ажиллуулсан `k6 version`-ийн яг output-ыг оруулна.

```text
TODO: paste `k6 version` output here
```

## 4. Суурь хэмжилт

Эхлээд 5 VU ачааллаар baseline хэмжилт хийсэн.

```bash
k6 run --vus 5 --duration 1m script.js | tee results/run-05vu.txt
```

Baseline p95 = **TODO ms**

## 5. 5 / 30 / 100 VU харьцуулалт

Даалгаврын шаардлагын дагуу нэг stages run-ийн нийлбэр summary-г хүснэгтэд шууд ашиглахгүй. Тусдаа 1 минутын туршилтаас авсан утгуудыг ашиглана.

```bash
k6 run --vus 5 --duration 1m script.js | tee results/run-05vu.txt
k6 run --vus 30 --duration 1m script.js | tee results/run-30vu.txt
k6 run --vus 100 --duration 1m script.js | tee results/run-100vu.txt
```

### Хэмжилтийн хүснэгт

| VU | p90 | p95 | Throughput (http_reqs/s) | Error rate |
|---:|---:|---:|---:|---:|
| 5 | TODO | TODO | TODO | TODO |
| 30 | TODO | TODO | TODO | TODO |
| 100 | TODO | TODO | TODO | TODO |

> **Анхаарах:** Дээрх TODO утгуудыг k6 output файлынхаа бодит утгаар солино. README-ийн хүснэгт болон `results/*.txt` файлын утгууд яг таарч байх ёстой.

## 6. Stages туршилт

Ачааллыг 5 → 30 → 100 VU болгон өсгөж, дараа нь 0 болгож бууруулсан.

```bash
k6 run stages.js | tee results/stages.txt
```

Stages-ийн зорилго нь ачаалал нэмэгдэх үеийн ерөнхий зан төлөвийг ажиглах юм.

## 7. SLO / Threshold

Даалгаврын дагуу SLO-г өөрийн baseline хэмжилтэд үндэслэнэ.

**Томъёо:**

```text
SLO p95 = baseline p95 × 1.5
```

Жишээ нь baseline p95 = 80 ms байсан бол SLO = 120 ms болно. Энэ нь зөвхөн жишээ бөгөөд 80 ms-ийг шууд ашиглахгүй.

Өөрийн baseline-ээс гаргасан утгаар PASS туршилтыг ажиллуулна:

```bash
k6 run -e SLO_P95_MS=YOUR_SLO threshold-pass.js | tee results/threshold-pass.txt
```

`YOUR_SLO`-г өөрийн baseline p95 × 1.5 утгаар солино.

FAIL туршилтыг зориудаар хатуу `p(95)<50` threshold ашиглан ажиллуулна:

```bash
k6 run threshold-fail.js | tee results/threshold-fail.txt
```

PASS болон FAIL-ийн terminal output-ыг screenshot болгон `screenshots/` хавтаст байрлуулна.

## 8. Хэмжсэн үзүүлэлтүүд

- **p90:** хүсэлтийн 90%-ийн хугацаа энэ утгаас бага буюу тэнцүү байна.
- **p95:** хүсэлтийн 95%-ийн хугацаа энэ утгаас бага буюу тэнцүү байна.
- **Throughput:** нэг секундэд боловсруулсан HTTP хүсэлтийн хэмжээ.
- **Error rate:** амжилтгүй HTTP хүсэлтийн хувь.
- **Availability:** систем хүсэлтэд амжилттай хариу өгч байгаа байдалтай холбоотой хэмжүүр.

## 9. Дүгнэлт

1. 5 VU ачаалалтай үед системийн p95 latency нь **TODO ms** байсан.
2. 30 VU үед p95 latency **TODO ms** болж өөрчлөгдсөн.
3. 100 VU үед p95 latency **TODO ms** болсон.
4. Ачаалал нэмэгдэхэд throughput **TODO** чиг хандлагатай байсан.
5. Error rate 5, 30 болон 100 VU үед тус бүр **TODO** байсан.
6. Туршилтаар latency болон throughput нь ачааллын өөрчлөлттэй хэрхэн хамааралтайг ажигласан.
7. Энэ нь гүйцэтгэлийн хэмжүүр болон ачааллын тестийн хичээлийн ойлголтуудыг практик байдлаар баталгаажуулсан.
8. Төслийн SLO p95 нь baseline p95-ийн 1.5 дахин үржвэрээр тодорхойлогдсон.
9. SLO threshold-ийн PASS/FAIL үр дүнг k6-ийн threshold механизмаар шалгасан.
10. Туршилтын бодит үр дүн нь тухайн компьютер, сүлжээ болон туршилт хийсэн үеийн нөхцөлөөс хамаарч өөрчлөгдөж болох тул output файлуудыг хамт хадгалсан.

> Эцсийн тайлан өгөхөөс өмнө TODO хэсгүүдийг өөрийн бодит хэмжилтээр солино.

## 10. Screenshot

Дараах screenshot-уудыг `screenshots/` хавтаст оруулна:

- 5 VU k6 summary
- 30 VU k6 summary
- 100 VU k6 summary
- Threshold PASS
- Threshold FAIL

## 11. Git commit

3-аас дээш commit хийх шаардлагатай.

Жишээ:

```bash
git add lab2/script.js
git commit -m "Add k6 baseline test"

git add lab2/stages.js
git commit -m "Add k6 stages test"

git add lab2/threshold-pass.js lab2/threshold-fail.js
git commit -m "Add k6 thresholds"

git add lab2/README.md lab2/results lab2/screenshots
git commit -m "Add k6 results and report"

git push origin HEAD
```

## 12. Шалгах жагсаалт

- [ ] Public GitHub repository
- [ ] k6 script ажилласан
- [ ] p90, p95, throughput, error rate зөв уншсан
- [ ] 5 / 30 / 100 VU тусдаа хэмжилт хийсэн
- [ ] stages test ажиллуулсан
- [ ] Threshold PASS output байгаа
- [ ] Threshold FAIL output байгаа
- [ ] SLO-г өөрийн baseline-ээс тооцсон
- [ ] `results/*.txt` output файлууд байгаа
- [ ] Screenshot-ууд байгаа
- [ ] README-ийн хүснэгт бодит output-той таарч байгаа
- [ ] 3+ commit хийсэн
- [ ] Teams дээр GitHub холбоосоо өгсөн
