好的，Mac 用戶的話就簡單多了！我幫你調整一下：

## 🍎 Mac 最簡單方案

### **推薦：Scorpiano** (在 Mac 上很穩定)

#### 安裝步驟：

```bash
# 1. 先裝 Homebrew（如果沒有的話）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 克隆專案
git clone https://github.com/BojanSof/scorpiano.git
cd scorpiano

# 3. 裝依賴（用 Homebrew + pip）
brew install python@3.9
python3 -m pip install numpy scipy librosa music21==6.7.1 MIDIUtil matplotlib

# 4. 跑程式（有 GUI）
python3 scorpiano.py
```

#### 使用流程：

1. **YouTube → MP3**
```bash
# 先裝 yt-dlp
brew install yt-dlp

# 下載影片音訊
yt-dlp -f 'bestaudio' -x --audio-format mp3 'https://www.youtube.com/watch?v=...'
```

2. **MP3 → WAV**
```bash
# 先裝 ffmpeg
brew install ffmpeg

# 轉換
ffmpeg -i song.mp3 song.wav
```

3. **WAV → 樂譜**
   - 跑 `python3 scorpiano.py`
   - 在 GUI 裡選你的 WAV 檔案
   - 輸出 PNG 或 MusicXML

---

## 或者試試 wav-to-sheetMusic（更新穎）

```bash
git clone https://github.com/aaronstone1699/wav-to-sheetMusic.git
cd wav-to-sheetMusic

pip3 install librosa crepe music21 soundfile noisereduce matplotlib tkinter

python3 main.py  # 會開 GUI 視窗
```

---

## 🎯 完整一鍵腳本（Mac）

我幫你寫一個 Mac 用的自動化腳本，要不要？這樣 YouTube URL → 樂譜 一次搞定。

你那個 YouTube 影片的連結是什麼歌曲？

腳本做好了，我沒辦法在這裡實際下載 YouTube 來測試，所以第一次跑如果出錯，把錯誤訊息貼給我就好。

我也要更正前面的建議：Scorpiano 只能處理**單音**（一次一個音），而且我說它在 Mac 上穩定，其實我沒有查證過。一般鋼琴曲有左右手和弦，所以這支腳本改用 Spotify 的 **Basic Pitch**，它支援多音轉錄。

**安裝（只需一次）：**

```bash
brew install yt-dlp ffmpeg python@3.11
python3.11 -m venv ~/score-env
source ~/score-env/bin/activate
pip install basic-pitch music21 demucs
```

**使用：**

```bash
source ~/score-env/bin/activate
python3 yt2score.py "https://www.youtube.com/watch?v=KOf3NY0PaA0"
```

如果這首歌有人聲或其他樂器，加上 `--separate`，會先用 Demucs 抽出鋼琴聲部，結果通常會乾淨很多：

```bash
python3 yt2score.py "https://www.youtube.com/watch?v=KOf3NY0PaA0" --separate
```

輸出在 `./score_output/`，有 `output.mid` 和 `output.musicxml`。用免費的 **MuseScore** 打開 `.musicxml` 就能看譜、修改、匯出 PDF。

自動轉譜很難一次完美，節奏量化和左右手分譜常常需要在 MuseScore 裡手動修一下。下載 YouTube 音訊也請只用在個人學習用途。