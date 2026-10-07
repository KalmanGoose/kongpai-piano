# 在 Mac 上學彈鋼琴曲：整理筆記

## 目前進度

- 目標：學彈《空拍 (Pause ll)》鋼琴曲（原曲 YouTube：`https://www.youtube.com/watch?v=KOf3NY0PaA0`，歌手：呂允 Lu Yun）
  - 原曲調性：**D♭ 大調**（若覺黑鍵多可移調為 **C 大調** 練習）
  - 拍號節奏：**3/4 拍** 慢板抒情（每小節三拍）
  - 配器結構：原曲主配器為**純鋼琴 + 大提琴**（無鼓與電貝斯，伴奏軌非常純淨，極適合直接轉譜）
- 環境：Mac
- [x] 已下載音檔
- [x] 已分離人聲與伴奏
- [x] 把伴奏轉成 MIDI / 樂譜（已使用 Basic Pitch 成功自伴奏軌轉錄出真實 MIDI 與 MusicXML）
- [ ] 在 MuseScore 裡開啟並開始練習

> 重點：目標是「學彈」，所以優先找現成的譜或教學，自動轉譜是備案，轉出來的譜一定要邊聽邊修。

---

## 🌟 呂允官方公布和弦（2019/1/11 IG 典藏）

- 詞/曲：呂允
- 原調：bD（D♭ 大調）
- Capo: 1（C 調指法）

```
[主歌 1]
Cadd9   G/B   Am7
不要說 他已遠走 而我卻停留

Am/G  Fsus2  C/E    Dm11  Gsus4  G
多少等候 落空 多少寂寞 滲透

Cadd9  G/B  Am7  Am/G
我想走 但始終埋沒 漩渦

Fsus2       C/E
疲憊抹去自我 無奈擊潰從容

Dm7        Gsus4  G
真正失去的比想像更多

[導歌 / Pre-Chorus] (★ 核心神轉位：E ➔ E/G#)
E       E/G#    Am7      Am/G
黑夜失眠簇擁內心喧囂煩悶的生活

Dm11(7)   D11(7)    Gsus4  G
一天天晃過 難以越過 那空洞

[副歌 / Chorus]
Cadd9       G/B   Am7
我一片空白 停滯在灰色地帶

Am/G  Fsus2     C/E
說不出內心感慨 步履蹣跚

Dm7     Gsus4  G
快點回來 就不哀嘆

Cadd9       G/B   Am7  Am/G
又一段空拍 停止在絕望塵埃

Fsus2       C/E
吹散陰霾 卸下重擔

Dm7   G   Cadd9
就算重來 並非 失敗
```

---

## 一、下一步：用伴奏音檔轉譜

音檔和人聲分離都已完成，所以不需要再下載，也不需要再加 `--separate`，直接把**伴奏檔**丟進腳本即可。

### 安裝（只需一次）

```bash
brew install ffmpeg python@3.11
python3.11 -m venv ~/score-env
source ~/score-env/bin/activate
pip install basic-pitch music21
```

> 已經下載好音檔，所以不用再裝 yt-dlp。只有想再抽出鋼琴聲部時才需要 `pip install demucs`。

### 執行

```bash
source ~/score-env/bin/activate
python3 yt2score.py ~/Downloads/伴奏檔名.wav -o ./score_output
```

`yt2score.py` 偵測到本機檔案會直接轉成 wav 再送進 Basic Pitch，支援 mp3、wav、m4a 等格式。

### 輸出

- `output.mid`：可丟進 Synthesia、GarageBand
- `output.musicxml`：用 MuseScore 開啟，可修改、列印、匯出 PDF

### 如果伴奏還有其他樂器

分離人聲後的「伴奏」可能還包含鼓、貝斯、弦樂等，轉出來的譜會有雜音。這時可以再用 Demucs 只抽鋼琴：

```bash
pip install demucs
python3 -m demucs -n htdemucs_6s --two-stems piano 伴奏檔名.wav
```

再把產生的 `piano.wav` 丟進 `yt2score.py`。

### 流程圖

```
伴奏 wav → (選用：Demucs 抽鋼琴) → Basic Pitch → MIDI → music21 → MusicXML → MuseScore
```

---

## 二、學彈的建議順序

1. **先找現成的譜**
   - musescore.com 搜「歌名 + piano」
   - YouTube 搜「歌名 + piano tutorial」，常有 Synthesia 風格的落下音符教學
2. **跟著原影片學**
   - YouTube 播放速度調成 0.5x 或 0.75x
   - 用 A-B 區段循環，一小段一小段練
3. **找不到譜，就用上面轉出的 MIDI / MusicXML**
   - 在 MuseScore 裡邊播放伴奏、邊對照修正，再當作練習用的譜

---

## 三、Mac 上可用的學習工具

| 工具 | 費用 | 用途 |
| --- | --- | --- |
| MuseScore | 免費 | 開譜、播放、調速、分左右手練習，可開 `.musicxml` |
| Synthesia | 付費 | MIDI 變落下音符畫面，不用會看譜 |
| Flowkey / Simply Piano / Piano Marvel | 訂閱制 | 互動式教學，可先搜有沒有這首 |
| Anytune / Transcribe! | 付費 | 原曲放慢不變調、循環，用耳朵找音 |
| GarageBand | 免費（Mac 內建） | 匯入 MIDI、接電子琴練習並錄音對照 |

最省事組合：**MuseScore + Synthesia（或 YouTube 教學）一起練**。

---

## 四、開源專案參考（GitHub）

| 專案 | 特點 | 備註 |
| --- | --- | --- |
| [Spotify Basic Pitch](https://github.com/spotify/basic-pitch) | 神經網路音訊轉 MIDI，支援多音 | 最適合一般鋼琴曲，腳本採用 |
| [Demucs](https://github.com/facebookresearch/demucs) | 分離人聲、鼓、鋼琴等聲部 | 可再抽出鋼琴 |
| [BojanSof/scorpiano](https://github.com/BojanSof/scorpiano) | 鋼琴自動轉譜 | **只支援單音**，不適合有和弦的曲子 |
| [aaronstone1699/wav-to-sheetMusic](https://github.com/aaronstone1699/wav-to-sheetMusic) | WAV → MIDI → 樂譜，有 GUI | 用 librosa、crepe、music21 |
| [Zulko/unroll](https://github.com/zulko/unroll) | 鋼琴捲簾影片或 MIDI 轉譜 | 輸出 Lilypond，專案較舊 |
| [Planetbiru/MusicXML](https://github.com/Planetbiru/MusicXML) | MIDI 轉 MusicXML / PDF / SVG | PHP 函式庫 |

---

## 注意事項

- 自動轉譜很難一次完美，節奏量化與左右手分譜常需手動修正
- 腳本尚未在實際環境測試，若出錯請把錯誤訊息貼出來除錯
- 音檔請只用於個人學習

---

## 待辦

- [x] 確認歌曲資訊（已確認為呂允《空拍 (Pause ll)》，原調 D♭ 大調，3/4 拍慢板）
- [x] 撰寫自動化轉譜腳本 [yt2score.py](file:///Users/ethanchen/Desktop/呂允/空拍/yt2score.py)（支援 macOS afconvert 格式轉換與 basic-pitch 轉錄）
- [x] 安裝 Python 套件（`pip install basic-pitch music21 onnxruntime`）
- [x] 執行轉譜腳本產出 MIDI 與 MusicXML（存放於 ./score_output/）
- [x] 製作 MacBook 鍵盤彈唱網頁練習器 (index.html / piano_coach.html)
- [x] 已推送到 GitHub 倉庫：https://github.com/KalmanGoose/kongpai-piano
- [x] 已啟用 GitHub Pages 線上版：https://kalmangoose.github.io/kongpai-piano/
