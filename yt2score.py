#!/usr/bin/env python3
"""
yt2score.py
將音訊檔案（伴奏、鋼琴曲等）轉換為 MIDI 與 MusicXML 樂譜檔。
使用 Spotify Basic Pitch 進行多音轉錄，並使用 music21 轉為 MuseScore 可讀取的 MusicXML。
"""

import os
import sys
import argparse
import subprocess
import shutil
from pathlib import Path

def convert_to_wav(input_path: Path, temp_dir: Path) -> Path:
    """將音訊格式轉成標準 44.1kHz 16-bit WAV"""
    if input_path.suffix.lower() == ".wav":
        return input_path

    wav_out = temp_dir / f"{input_path.stem}.wav"
    print(f"[*] 正在將音訊轉換為 WAV: {input_path.name} -> {wav_out.name}")

    # 優先嘗試 ffmpeg
    if shutil.which("ffmpeg"):
        cmd = ["ffmpeg", "-y", "-i", str(input_path), "-ar", "22050", "-ac", "1", str(wav_out)]
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return wav_out

    # macOS 原生 afconvert 備援
    if shutil.which("afconvert"):
        cmd = ["/usr/bin/afconvert", "-f", "WAVE", "-d", "LEI16@22050", "-c", "1", str(input_path), str(wav_out)]
        subprocess.run(cmd, check=True)
        return wav_out

    raise RuntimeError("系統中未找到 ffmpeg 或 afconvert，無法轉換音訊格式。")

def audio_to_score(audio_path: Path, output_dir: Path):
    """執行 Basic Pitch 轉錄與 music21 格式轉換"""
    output_dir.mkdir(parents=True, exist_ok=True)
    temp_dir = output_dir / ".temp"
    temp_dir.mkdir(parents=True, exist_ok=True)

    try:
        # 1. 確保音訊為 wav
        wav_path = convert_to_wav(audio_path, temp_dir)

        # 2. 匯入 basic-pitch
        print("[*] 正在載入 Basic Pitch 模型轉錄音訊為 MIDI...")
        from basic_pitch import ICASSP_2022_MODEL_PATH
        from basic_pitch.inference import predict_and_save
        
        # 3. 預測並輸出 MIDI
        predict_and_save(
            audio_path_list=[str(wav_path)],
            output_directory=str(output_dir),
            save_midi=True,
            sonify_midi=False,
            save_model_outputs=False,
            save_notes=False,
            model_or_model_path=ICASSP_2022_MODEL_PATH
        )

        # Basic Pitch 預設輸出的 midi 檔名通常為 <stem>_basic_pitch.mid
        expected_midi = output_dir / f"{wav_path.stem}_basic_pitch.mid"
        target_midi = output_dir / f"{audio_path.stem}.mid"

        if expected_midi.exists():
            if target_midi.exists():
                target_midi.unlink()
            expected_midi.rename(target_midi)

        print(f"[✓] MIDI 產生成功: {target_midi}")

        # 4. 透過 music21 轉為 MusicXML
        print("[*] 正在使用 music21 將 MIDI 轉換為 MusicXML...")
        try:
            import music21
            score = music21.converter.parse(str(target_midi))
            target_xml = output_dir / f"{audio_path.stem}.musicxml"
            score.write("musicxml", fp=str(target_xml))
            print(f"[✓] MusicXML 樂譜產生成功: {target_xml}")
        except ImportError:
            print("[!] 未安裝 music21，跳過 MusicXML 產生。可手動將 .mid 檔匯入 MuseScore。")
        except Exception as e:
            print(f"[!] MusicXML 轉換時發生警告: {e}，請直接使用 .mid 匯入 MuseScore。")

        print("\n" + "="*50)
        print("🎉 轉譜完成！你可以：")
        print(f"1. 打開 MuseScore，匯入：{target_midi.name} 或 {audio_path.stem}.musicxml")
        print(f"2. 匯入 Synthesia 或 GarageBand 練習彈奏")
        print("="*50)

    finally:
        # 清理暫存檔
        if temp_dir.exists():
            shutil.rmtree(temp_dir, ignore_errors=True)

def main():
    parser = argparse.ArgumentParser(description="音訊轉鋼琴樂譜工具 (Basic Pitch + music21)")
    parser.add_argument("input", help="輸入音訊檔案路徑 (例如: 伴奏.m4a, 伴奏.wav)")
    parser.add_argument("-o", "--output", default="./score_output", help="輸出資料夾路徑 (預設: ./score_output)")
    args = parser.parse_args()

    input_path = Path(args.input).expanduser().resolve()
    if not input_path.exists():
        print(f"[錯誤] 找不到檔案: {input_path}")
        sys.exit(1)

    output_dir = Path(args.output).expanduser().resolve()
    audio_to_score(input_path, output_dir)

if __name__ == "__main__":
    main()
