//
//  Test.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/23.
//  Copyright © 2020 小原 宙. All rights reserved.
//
//
//import SwiftUI
//
//struct Test: View {
//    var body: some View {
//        
//        List {
//            Text("大根")
//        }
//        .onAppear {
//            var datesArray: [[String]] = []
//                var date: [String] = []
//                var wday = 0
//                
//                for i in 2019...2025 {
//                    for j in 1...12 {
//                        for k in 1...31 {
//                            if i == 2019 && j < 9 {
//                                break
//                            }
//                            date.append(String(i))
//                            date.append(String(j))
//                            date.append(String(k))
//                            date.append(String(wday))
//                            
//                            switch (i, j, k, wday) {
//                            case (_, 1, 1, _):
//                                date.append("元日")
//                            case (_, 1, 2, 1):
//                                date.append("振替休日")
//                            case (_, 1, 8...14, 1):
//                                date.append("成人の日")
//                            //2月11日: 建国記念の日
//                            case (_, 2, 11, _):
//                                date.append("建国記念の日")
//                            //2月12日: 振替休日
//                            case (_, 2, 12, 1):
//                                date.append("振替休日")
//                            //2月23日(2020年から): 天皇誕生日
//                            case (i, 2, 23, _) where i >= 2020:
//                                date.append("天皇誕生日")
//                            //2月24日(2020年から): 天皇誕生日の振替休日
//                            case (i, 2, 24, 1) where i >= 2020:
//                                date.append("振替休日")
//                            //3月20日 or 21日: 春分の日
//                            case (i, 3, 20, _) where i == 2020 || i == 2021 || i == 2024 || i == 2025:
//                                date.append("春分の日")
//                            case (i, 3, 21, _) where i == 2019 || i == 2022 || i == 2023:
//                                date.append("春分の日")
//                            //4月29日: 1949年から1989年までは天皇誕生日、1990年から2006年まではみどりの日、2007年以降は昭和の日
//                            case (_, 4, 29, _):
//                                date.append("昭和の日")
//                            //4月30日: 振替休日
//                            case (_, 4, 30, 1):
//                                date.append("振替休日")
//                            //2019年5月1日： 2019年だけ天皇の即位の日
//                            case (2019, 5, 1, _):
//                                date.append("天皇の即位の日")
//                            //5月3日: 1949年から憲法記念日
//                            case (_, 5, 3, _):
//                                date.append("憲法記念日")
//                            //5月4日: 1988年から2006年まで国民の休日、2007年以降はみどりの日
//                            case (_, 5, 4, _):
//                                date.append("みどりの日")
//                            //5月5日: 1949年からこどもの日
//                            case (_, 5, 5, _):
//                                date.append("こどもの日")
//                            //ゴールデンウィークの振替休日
//                            case (i, 5, 6, _) where i == 2019 || i == 2020 || i == 2024 || i == 2025 || i == 2026:
//                                date.append("振替休日")
//                            //7月の第3月曜日(2003年から)、7月23日(2020年のみ): 海の日
//                            case (i, 7, 15...21, 1) where i != 2020:
//                                date.append("海の日")
//                            case (2020, 7, 23, _):
//                                date.append("海の日")
//                            //8月11日(2016年から)、8月10日(2020年のみ): 山の日
//                            case (i, 8, 11, _) where i != 2020:
//                                date.append("山の日")
//                            case (2020, 8, 10, _):
//                                date.append("山の日")
//                            //8月12日: 山の日の振替休日
//                            case (_, 8, 12, 1):
//                                date.append("振替休日")
//                            //9月15日(1966年から2002年まで)、9月の第3月曜日(2003年から): 敬老の日
//                            case (_, 9, 15...21, 1):
//                                date.append("敬老の日")
//                            //9月22日 or 23日: 秋分の日
//                            case (i, 9, 22, _) where i == 2020 || i == 2024:
//                                date.append("秋分の日")
//                            case (i, 9, 23, _) where i == 2019 || i == 2021 || i == 2022 || i == 2023 || i == 2025:
//                                date.append("秋分の日")
//                            //秋分の日の次が月曜日: 振替休日
//                            case (2024, 9, 23, 1):
//                                date.append("振替休日")
//                            //(1).10月10日(1966年から1999年まで)、(2).10月の第2月曜日(2000年から)、(3).7月24日(2020年のみ): 体育の日(スポーツの日)
//                            case (i, 10, 8...14, 1) where i < 2020:
//                                date.append("体育の日")
//                            case (i, 10, 8...14, 1) where i > 2020:
//                                date.append("スポーツの日")
//                            case (2020, 7, 24, _):
//                                date.append("スポーツの日")
//                            //2019年10月22日： 2019年だけ即位礼正殿の儀
//                            case (2019, 10, 22, _):
//                                date.append("即位礼正殿の儀")
//                            //11月3日: 1948年から文化の日
//                            case (_, 11, 3, _):
//                                date.append("文化の日")
//                            //11月4日: 振替休日
//                            case (_, 11, 4, 1):
//                                date.append("振替休日")
//                            //11月23日: 1948年から勤労感謝の日
//                            case (_, 11, 23, _):
//                                date.append("勤労感謝の日")
//                            //11月24日: 振替休日
//                            case (_, 11, 24, 1):
//                                date.append("振替休日")
//                            //12月23日(1989年から2018年まで): 天皇誕生日
//                            case (1990...2018, 12, 23, _):
//                                date.append("天皇誕生日")
//                            //12月24日(1989年から2018年まで): 天皇誕生日の振替休日
//                            case (1990...2018, 12, 24, 1):
//                                date.append("振替休日")
//                            default:
//                                date.append("")
//                            }
//                                
//                            datesArray.append(date)
//                            date = []
//                            
//                            wday += 1
//                            if wday > 6 {
//                                wday = 0
//                            }
//                            if j == 2 {
//                                if i % 4 == 0 && i % 100 != 0 || i % 400 == 0 {
//                                    if k > 28 {
//                                        break
//                                    }
//                                } else if k > 27 {
//                                    break
//                                }
//                            }
//                            if j == 4 || j == 6 || j == 9 || j == 11 {
//                                if k > 29 {
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//            print(datesArray)
//        }
//    }
//}
//
//struct Test_Previews: PreviewProvider {
//    static var previews: some View {
//        Test()
//    }
//}
