import cv2
import numpy as np
from sklearn.cluster import KMeans
from collections import Counter

# 为了给每个像素找到最接近的颜色，计算每个像素到聚类中心的距离
def get_nearest_color(pixel, centers):
    distances = np.linalg.norm(centers - pixel, axis=1)
    nearest_color_idx = np.argmin(distances)
    return centers[nearest_color_idx], nearest_color_idx

if __name__ == '__main__':
    # 视频文件路径
    video_path = 'Never Gonna Give You Up.mp4'

    # 打开视频文件
    cap = cv2.VideoCapture(video_path)
    # 获取视频的帧率（fps）
    fps = cap.get(cv2.CAP_PROP_FPS)
    # 获取视频的总帧数
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    # 设置截取间隔为每秒一帧
    frame_interval = int(fps) // 4

    # 用于存储每秒截取的画面颜色数据
    colors = []
    all_pixels = []
    frame_number = 0
    # while frame_number < 201 * frame_interval:
    #     ret, frame = cap.read()
        
    #     if not ret:
    #         break
        
    #     # 每隔一秒截取一个画面
    #     if frame_number % frame_interval == 0:
    #         # 将画面缩放到 320x200
    #         resized_frame = cv2.resize(frame, (320, 200))
    #         # cv2.imshow("Resized Image", resized_frame.astype(np.uint8))
    #         # cv2.waitKey(0)
    #         # cv2.destroyAllWindows()
    #         # 将每个像素的BGR值转换为RGB
    #         pixels = resized_frame.reshape(-1, 3)

    #         # 使用KMeans聚类算法提取256种颜色
    #         kmeans = KMeans(n_clusters=64, random_state=42)
    #         kmeans.fit(pixels)
    #         # 获取聚类中心（即最常见的颜色）
    #         pixels = kmeans.cluster_centers_

    #         if frame_number > 0:
    #             all_pixels = np.vstack((all_pixels, pixels[range(16)]))
    #         else:
    #             all_pixels = pixels[range(16)]

    #         print(frame_number // frame_interval)
        
    #     frame_number += 1

    # # 使用KMeans聚类算法提取224种颜色
    # kmeans = KMeans(n_clusters = 224, random_state=42)
    # kmeans.fit(all_pixels)
    # # 获取聚类中心（即最常见的颜色）
    # dominant_colors = kmeans.cluster_centers_
    # # 获取每个像素所属的簇标签
    # labels = kmeans.labels_

    # # 输出最常见的224种颜色（以RGB格式）
    # dominant_colors = dominant_colors.astype(int)
    # print("Dominant Colors (RGB):")
    # for color in dominant_colors:
    #     print(color)

    # dominant_colors = [
    #     [0, 0, 0],[0, 0, 170],[0, 170, 0],[0, 170, 170],[170, 0, 0],[170, 0, 170],[170, 85, 0],[170, 170, 170],
    #     [85, 85, 85],[85, 85, 255],[85, 255, 85],[85, 255, 255],[255, 85, 85],[255, 85, 255],[255, 255, 85],[255, 255, 255],
    #     [0, 255, 0],[0, 255, 85],[0, 255, 170],[0, 255, 255],[255, 0, 0],[255, 0, 255],[255, 85, 0],[255, 170, 0],
    #     [255, 255, 0],[255, 170, 255],[255, 255, 85],[255, 255, 170],[170, 85, 255],[170, 170, 255],[85, 85, 255],[255, 255, 255]
    # ]

    # dominant_colors = [
    #     [96,96,96],[208,208,208],[24,24,24],[165,165,165],[112,112,112],[236,236,236],[19,19,19],[72,72,72],
    #     [15,15,15],[90,90,90],[239,239,239],[194,194,194],[75,75,75],[158,158,158],[130,130,130],[235,235,235],
    #     [19,19,19],[237,237,237],[58,58,58],[114,114,114],[189,189,189],[57,57,57],[54,54,54],[51,51,51],
    #     [165,165,165],[190,190,190],[18,18,18],[70,70,70],[16,16,16],[235,235,235],[165,165,165],[56,56,56],
    #     [104,104,104],[200,200,200],[186,186,186],[238,238,238],[61,61,61],[160,160,160],[162,162,162],[233,233,233],
    #     [235,235,235],[18,18,18],[86,86,86],[138,138,138],[145,145,145],[18,18,18],[59,59,59],[121,121,121],
    #     [194,194,194],[107,107,107],[162,162,162],[157,157,157],[133,133,133],[237,237,237],[18,18,18],[56,56,56],
    #     [54,54,54],[136,136,136],[233,233,233],[19,19,19],[205,205,205],[233,233,233],[20,20,20],[17,17,17],
    #     [106,106,106],[21,21,21],[203,203,203],[237,237,237],[18,18,18],[100,100,100],[78,78,78],[94,94,94],
    #     [205,205,205],[180,180,180],[17,17,17],[234,234,234],[205,205,205],[237,237,237],[90,90,90],[166,166,166],
    #     [231,231,231],[110,110,110],[235,235,235],[60,60,60],[21,21,21],[59,59,59],[18,18,18],[126,126,126],
    #     [235,235,235],[137,137,137],[136,136,136],[142,142,142],[90,90,90],[19,19,19],[202,202,202],[60,60,60],
    #     [60,60,60],[238,238,238],[155,155,155],[184,184,184],[161,161,161],[197,197,197],[98,98,98],[50,50,50],
    #     [165,165,165],[50,50,50],[203,203,203],[125,125,125],[22,22,22],[141,141,141],[206,206,206],[56,56,56],
    #     [115,115,115],[136,136,136],[176,176,176],[161,161,161],[23,23,23],[142,142,142],[101,101,101],[55,55,55],
    #     [98,98,98],[239,239,239],[138,138,138],[18,18,18],[146,146,146],[234,234,234],[167,167,167],[16,16,16],
    #     [67,67,67],[51,51,51],[198,198,198],[111,111,111],[203,203,203],[154,154,154],[132,132,132],[63,63,63],
    #     [236,236,236],[159,159,159],[199,199,199],[199,199,199],[142,142,142],[20,20,20],[201,201,201],[234,234,234],
    #     [237,237,237],[53,53,53],[168,168,168],[236,236,236],[16,16,16],[91,91,91],[235,235,235],[92,92,92],
    #     [91,91,91],[105,105,105],[17,17,17],[120,120,120],[152,152,152],[55,55,55],[237,237,237],[205,205,205],
    #     [236,236,236],[127,127,127],[202,202,202],[163,163,163],[77,77,77],[199,199,199],[90,90,90],[202,202,202],
    #     [163,163,163],[232,232,232],[187,187,187],[234,234,234],[18,18,18],[110,110,110],[21,21,21],[55,55,55],
    #     [56,56,56],[239,239,239],[201,201,201],[20,20,20],[175,175,175],[93,93,93],[61,61,61],[61,61,61],
    #     [111,111,111],[201,201,201],[20,20,20],[192,192,192],[110,110,110],[52,52,52],[196,196,196],[233,233,233],
    #     [48,48,48],[90,90,90],[133,133,133],[49,49,49],[55,55,55],[119,119,119],[84,84,84],[54,54,54],  
    #     [168,168,168],[23,23,23],[56,56,56],[18,18,18],[188,188,188],[15,15,15],[188,188,188],[228,228,228],
    #     [17,17,17],[187,187,187],[138,138,138],[190,190,190],[203,203,203],[165,165,165],[59,59,59],[123,123,123],
    #     [238,238,238],[127,127,127],[18,18,18],[81,81,81],[88,88,88],[91,91,91],[238,238,238],[74,74,74],
    #     [144,144,144],[234,234,234],[20,20,20],[130,130,130],[164,164,164],[86,86,86],[133,133,133],[163,163,163],
    #     [237,237,237],[91,91,91],[89,89,89],[174,174,174],[183,183,183],[17,17,17],[136,136,136],[194,194,194],
    #     [95,95,95],[233,233,233],[130,130,130],[95,95,95],[138,138,138],[47,47,47],[238,238,238],[51,51,51],
    #     [100,100,100],[19,19,19],[115,115,115],[16,16,16],[17,17,17],[122,122,122],[202,202,202],[155,155,155]
    # ]

    # dominant_colors = [
    #     [0, 0, 0],[0, 0, 20],[0, 20, 0],[0, 20, 20],[20, 0, 0],[20, 0, 20],[20, 10, 0],[20, 20, 20],
    #     [10, 10, 10],[10, 10, 30],[10, 30, 10],[10, 30, 30],[30, 10, 10],[30, 10, 30],[30, 30, 10],[30, 30, 30],
    #     [0, 30, 0],[0, 30, 30],[0, 30, 20],[0, 30, 30],[30, 0, 0],[30, 0, 30],[30, 10, 0],[30, 20, 0],
    #     [30, 30, 0],[30, 20, 30],[30, 30, 10],[30, 30, 20],[20, 10, 30],[20, 20, 30],[10, 10, 30],[30, 30, 30]
    # ]

    # for j in range(32):
    #     dominant_color = dominant_colors[j]
    #     for i in range(2,9):
    #         dominant_colors.append([int(dominant_color[0]*i),int(dominant_color[1]*i),int(dominant_color[2]*i)])

    # dominant_colors = [
    #     [0, 0, 0],[0, 0, 15],[0, 15, 0],[0, 15, 15],[15, 0, 0],[15, 0, 15],[15, 15, 0],[15, 15, 15],
    #     [0, 8, 15],[8, 0, 15],[0, 8, 15],[0, 15, 8],[15, 0, 8],[15, 8, 0],[8, 8, 8],[15, 15, 15],
    # ]

    # for j in range(16):
    #     dominant_color = dominant_colors[j]
    #     for i in range(2,17):
    #         dominant_colors.append([int(dominant_color[0]*i),int(dominant_color[1]*i),int(dominant_color[2]*i)])

    # print(dominant_colors)
    # print(len(dominant_colors))
    
    # dominant_colors = []
    # colors = []
    # for i in range(0,256,11):
    #     for j in range(0,256,7):
    #         for k in range(0,256,13):
    #             colors.append([i, j, k])
    # gap = int(len(colors) / 256)
    # for i in range(0, len(colors), gap):
    #     dominant_colors.append(colors[i])

    # for i in range(0, 256, 5):
    #     for j in range(0, i, 3):
    #         if j % 2 == 0:
    #             for k in range(i - j, int(255/3), 5):
    #                 if k % 2 == 0:
    #                     for l in range(i - j -k, 255, 7):
    #                         colors.append([j, k, l])
    #                 else:
    #                     for l in range(0, 255, 13):
    #                         colors.append([j, k, l])
    #         else:
    #             for k in range(int(255/3), i - j, 5):
    #                 for l in range(i - j -k, 255, 7):
    #                     colors.append([j, k, l])

    # # 使用KMeans聚类算法提取256种颜色
    # kmeans = KMeans(n_clusters=256, random_state=42)
    # kmeans.fit(colors)
    # # 获取聚类中心（即最常见的颜色）
    # dominant_colors = kmeans.cluster_centers_
    # # 获取每个像素所属的簇标签
    # labels = kmeans.labels_

    # # 输出最常见的256种颜色（以RGB格式）
    # dominant_colors = dominant_colors.astype(int)
    # print("Dominant Colors (RGB):")
    # i = 0
    # for color in dominant_colors:
    #     print("[", end='')
    #     print(color[0], end=',')
    #     print(color[0], end=',')
    #     print(color[0], end='')
    #     i += 1
    #     if(i % 8 == 0):
    #         print("],")
    #     else:
    #         print("]", end=',')

    # filename = "colors.txt"
    # print("open file")
    # with open(filename, 'wb') as f:
    #     # for dominant_color in dominant_colors:
    #     #     print(dominant_color)
    #     # for idx in indices:
    #     #     print(idx)
        
    #     # 写入 dominant_colors
    #     for dominant_color in dominant_colors:
    #         temp = np.array(dominant_color, dtype=np.uint8)
    #         f.write(temp.tobytes())

    # 打开视频文件
    cap = cv2.VideoCapture(video_path)
    # 循环遍历视频的每一帧
    frame_number = 0
    while frame_number <= 848 * frame_interval:
        ret, frame = cap.read()
        
        if not ret:
            break
        
        # 每隔一秒截取一个画面
        if frame_number % frame_interval == 0:
            # 将画面缩放到 320x200
            resized_frame = cv2.resize(frame, (320, 200))
            # cv2.imshow("Resized Image", resized_frame.astype(np.uint8))
            # cv2.waitKey(0)
            # cv2.destroyAllWindows()
            # 将每个像素的BGR值转换为RGB
            all_pixels = resized_frame.reshape(-1, 3)

            # 使用KMeans聚类算法提取224种颜色
            kmeans = KMeans(n_clusters = 224, random_state=42)
            kmeans.fit(all_pixels)
            # 获取聚类中心（即最常见的颜色）
            dominant_colors = kmeans.cluster_centers_
            # 获取每个像素所属的簇标签
            labels = kmeans.labels_

            # # 输出最常见的224种颜色（以RGB格式）
            # dominant_colors = dominant_colors.astype(int)
            # print("Dominant Colors (RGB):")
            # for color in dominant_colors:
            #     print(color)

            # 将每个像素替换为最接近的颜色，并获取索引
            recolored_pixels = []
            indices = []
            for pixel in all_pixels:
                color, idx = get_nearest_color(pixel, dominant_colors)
                recolored_pixels.append(color)
                indices.append(idx)
            # 将重新着色的像素数据重塑回原图像形状
            recolored_image = np.array(recolored_pixels).reshape(resized_frame.shape)

            # 将重新着色后的图像显示出来
            # cv2.imshow("Recolored Image", recolored_image.astype(np.uint8))
            # cv2.waitKey(0)
            # cv2.destroyAllWindows()

            filename = "pic" + str(frame_number // frame_interval).zfill(3) + ".txt"

            # 写入文件
            with open(filename, 'wb') as f:
                # for dominant_color in dominant_colors:
                #     print(dominant_color)
                #for idx in indices:
                    #print(idx)
                
                # 写入 dominant_colors
                for dominant_color in dominant_colors:
                    dominant_color[0] = dominant_color[0] * 63.0 / 255.0
                    dominant_color[1] = dominant_color[1] * 63.0 / 255.0
                    dominant_color[2] = dominant_color[2] * 63.0 / 255.0
                    temp = np.array(dominant_color, dtype=np.uint8)
                    f.write(temp[2].tobytes())
                    f.write(temp[1].tobytes())
                    f.write(temp[0].tobytes())

                # 写入 indices
                for idx in indices:
                    f.write(np.uint8(idx+32).tobytes())
            
            print(frame_number // frame_interval)
        
        frame_number += 1

    # 释放视频文件
    cap.release()
