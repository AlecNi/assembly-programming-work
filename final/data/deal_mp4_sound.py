import moviepy as mp
import numpy as np
import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    # # 提取视频中的音频
    # video_path = 'Never Gonna Give You Up.mp4'
    # video = mp.VideoFileClip(video_path)

    # # 提取音频并保存为文件
    # audio = video.audio
    # audio_path = 'extracted_audio.wav'
    # audio.write_audiofile(audio_path)

    # 加载音频文件
    audio_path = 'extracted_audio.wav'
    y, sr = librosa.load(audio_path, sr=None)

    # 每秒采样6次，获取每1/6秒的频率
    sampling_points = 1200

    # 计算短时傅里叶变换（STFT）
    D = np.abs(librosa.stft(y))

    # 获取频率和时间轴
    frequencies = librosa.fft_frequencies(sr=sr)
    times = librosa.frames_to_time(np.arange(D.shape[-1]), sr=sr)

    # 每1/6秒提取频率信息
    frequencies_6_per_second = []

    for i in range(0, len(times), len(times) // sampling_points):
        # 获取当前时间点的频谱数据
        frame_freqs = D[:, i]  # 当前时间点的频率成分（幅度谱）
        
        # 获取幅度最大的频率
        max_freq_idx = np.argmax(frame_freqs)  # 找到幅度最大的频率索引
        dominant_freq = frequencies[max_freq_idx]  # 对应的频率就是主频
        
        temp = 1193180 // dominant_freq
        frequencies_6_per_second.append(np.int16(temp).tobytes())
        print(f"Time: {times[i]:.2f}s, Dominant Frequency: {dominant_freq:.2f}Hz")

    # 输出每1/6秒的频率信息
    print("Frequencies per 1/6 second:", frequencies_6_per_second)
    print(len(frequencies_6_per_second))

    filename = "sound.txt"
    # 写入文件
    with open(filename, 'wb') as f:
        # 写入 dominant_colors
        for i in range(len(frequencies_6_per_second)):
            if i < 1200:
                f.write(frequencies_6_per_second[i])
            else:
                break
