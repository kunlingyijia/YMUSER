//
//  FakeData.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "FakeData.h"
#import "HomePage/Model/HomeAdModel.h"
#import "MerchantModel.h"
#import "ImageModel.h"
#import "HomeShopModel.h"
#import "MerchantModel.h"
#import "MerchantCategoryModel.h"
#import "MerchantModel.h"
#import "GoodsModel.h"
#import "GovModel.h"
#import "AdressModel.h"
@implementation FakeData
+ (NSArray *)getHomePageAdData{
    HomeAdModel *m1 = [[HomeAdModel alloc] init];
    m1.homeAdId = @"100";
    m1.iconUrl = @"http://img5.imgtn.bdimg.com/it/u=3457577959,3841780082&fm=206&gp=0.jpg";
    m1.type = 0;
    
    MerchantModel *merchant = [[MerchantModel alloc] init];
    merchant.merchantId = @"1";
    merchant.merchantName = @"麻辣小龙虾";
    merchant.address = @"福州永同昌大厦十八楼 东吴科技";
    merchant.applauseRate = @"0.5";
    merchant.merchantInfo = @"商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍商家介绍";
//    merchant.images = [NSArray arrayWithObjects:@"http://img5.imgtn.bdimg.com/it/u=695606895,1890595448&fm=21&gp=0.jpg",@"http://img3.imgtn.bdimg.com/it/u=1951260715,3391326240&fm=21&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=2523311934,257591470&fm=21&gp=0.jpg",@"http://img3.imgtn.bdimg.com/it/u=4054478637,3240374590&fm=21&gp=0.jpg",@"http://imgs.huangye88.com/users/2011/11/01/e4611d52c7449f68.jpg", nil];
//    merchant.coupons = [NSArray arrayWithObjects:@"http://img4.imgtn.bdimg.com/it/u=1299637594,3599698594&fm=21&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=1299637594,3599698594&fm=21&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=1299637594,3599698594&fm=21&gp=0.jpg", nil];
    
    
    
    
    
    
    
    
    
    
    ImageModel *img1 = [[ImageModel alloc] init];
    img1.imageUrl = @"http://img5.imgtn.bdimg.com/it/u=3457577959,3841780082&fm=206&gp=0.jpg";
    img1.imageId = @"11";
    img1.imageDes = @"这是拍摄于5.1";
    
    ImageModel *img2 = [[ImageModel alloc] init];
    img2.imageUrl = @"http://img5.imgtn.bdimg.com/it/u=3457577959,3841780082&fm=206&gp=0.jpg";
    img2.imageId = @"11";
    img2.imageDes = @"这是拍摄于5.1";
    
    merchant.images = [NSArray arrayWithObjects:img1, img1, img2, nil];
    
    m1.merchant = merchant;
    
    
    
    HomeAdModel *m2 = [[HomeAdModel alloc] init];
    m2.homeAdId = @"101";
    m2.iconUrl = @"http://img00.hc360.com/hotelsupplies/201506/201506241421005540.jpg";
    m2.type = 1;
    
    
    HomeAdModel *m3 = [[HomeAdModel alloc] init];
    m3.homeAdId = @"102";
    m3.iconUrl = @"http://photocdn.sohu.com/20150724/mp24102935_1437706926636_3.jpeg";
    m3.type = 2;
    
    
    
    NSArray *data = [NSArray arrayWithObjects:m1,m2,m3, nil];
    return data;
}

+ (NSArray*)getHomePageShopData {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"11";
    m1.merchantName = @"肯德基";
    m1.iconUrl = @"http://pic9.nipic.com/20100903/5483130_133803793654_2.jpg";
    m1.applauseRate = @"0.5";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"12";
    m2.merchantName = @"德克士";
    m2.iconUrl = @"http://hiphotos.baidu.com/product_name/pic/item/2e2eb9389b504fc2584a72b5e4dde71190ef6d6d.jpg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"13";
    m3.merchantName = @"麻辣香锅";
    m3.iconUrl = @"http://imgsrc.baidu.com/forum/pic/item/c14e7c3e6709c93d5d46bc049f3df8dcd0005461.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"14";
    m4.merchantName = @"香洋洋火锅";
    m4.iconUrl = @"http://p5.img.brtn.cn/photoworkspace/contentimg/2014/09/04/2014090409580842683.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"15";
    m5.merchantName = @"韩国烧烤";
    m5.iconUrl = @"http://img1.cache.netease.com/catchpic/2/2C/2C65CA0F8AF3FDFB630C52C96519E17D.jpg";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}





+ (NSArray *)getMerchantData {
    MerchantModel *m1 = [[MerchantModel alloc] init];
    m1.merchantId = @"11";
    m1.merchantName = @"肯德基";
    m1.iconUrl = @"http://pic9.nipic.com/20100903/5483130_133803793654_2.jpg";
    m1.applauseRate = @"0.6";
    m1.merchantInfo = @"传统餐饮企业O2O转型先锋肯德基[1]  ，近日再次传出进军移动互联网的一大捷报：2014年12月20—29日期间，肯德基联合腾讯应用宝进行的“圣诞送豪礼”活动，在短短十天内，APP下载量即超40万，日均4万的下载量较同类传统餐饮企业APP的有近100倍的提升";
    
    GoodsModel *n1 = [[GoodsModel alloc] init];
    n1.name = @"套餐一,建议1-2人使用";
    n1.image = @"http://shanxi.sinaimg.cn/2011/0919/U6837P1196DT20110919192643.jpg";
    n1.firstPrice = @"98";
    n1.secondPrice = @"158";
    n1.sellNum = @"1574";
    
    GoodsModel *n2 = [[GoodsModel alloc] init];
    n2.name = @"套餐二,建议1人使用";
    n2.image = @"http://p1.meituan.net/320.0.a/deal/f7ad7a044c8a7db77ae8e8cb37ef71d580320.jpg";
    n2.firstPrice = @"78";
    n2.secondPrice = @"126";
    n2.sellNum = @"1657";
    
    GoodsModel *n3 = [[GoodsModel alloc] init];
    n3.name = @"套餐三,建议3-4人使用";
    n3.image = @"http://www.jitu5.com/uploads/allimg/110412/2238-11041210354680.jpg";
    n3.firstPrice = @"153";
    n3.secondPrice = @"120";
    n3.sellNum = @"2654";
    
    m1.goods = [NSArray arrayWithObjects:n1,n2,n3, nil];

    
    
    
    
    
    MerchantModel *m2 = [[MerchantModel alloc] init];
    m2.merchantId = @"12";
    m2.merchantName = @"德克士";
    m2.iconUrl = @"http://hiphotos.baidu.com/product_name/pic/item/2e2eb9389b504fc2584a72b5e4dde71190ef6d6d.jpg";
    m2.applauseRate = @"0.1";
    m2.merchantInfo = @"德克士是中国西式快餐特许加盟第一品牌，最大的加盟连锁舒食快餐企业，德克士炸鸡起源于美国南部的德克萨斯州，1994年出现在中国成都。1996年，顶新集团将德克士收购，并投入5000万美元，健全经营体系，完善管理系统，并重新建立了CIS系统，使其成为顶新集团继“康师傅”之后的兄弟品牌。虽然都是炸鸡，但是由于德克士炸鸡采用开口锅炸制，因此鸡块具有金黄酥脆、鲜美多汁的特点，并以此与肯德基炸鸡形成鲜明差别。德克士最有名的就是脆皮炸鸡，在中国快餐界其中最有名的三巨头：除了麦当劳、肯德基、还有就是德克士！";
    
    GoodsModel *y1 = [[GoodsModel alloc] init];
    y1.name = @"套餐一,建议1-2人使用";
    y1.image = @"http://s1.nuomi.bdimg.com/upload/deal/2012/5/V_L/55763-1336040547740.jpg";
    y1.firstPrice = @"68";
    y1.secondPrice = @"120";
    y1.sellNum = @"954";
    
    GoodsModel *y2 = [[GoodsModel alloc] init];
    y2.name = @"套餐二,建议3-4人使用";
    y2.image = @"http://www.lsfc.net.cn/Article/UploadFiles/201203/2012032815400100.jpg";
    y2.firstPrice = @"168";
    y2.secondPrice = @"255";
    y2.sellNum = @"1105";
    
    GoodsModel *y3 = [[GoodsModel alloc] init];
    y3.name = @"套餐三,建议2-3人使用";
    y3.image = @"http://p1.meituan.net/460.280/deal/73c0a28e0f8c59e425bffc72dc015dc296930.jpg";
    y3.firstPrice = @"136";
    y3.secondPrice = @"150";
    y3.sellNum = @"750";
    
    m2.goods = [NSArray arrayWithObjects:y1,y2,y3, nil];
    
    
    
    
    
    MerchantModel *m3 = [[MerchantModel alloc] init];
    m3.merchantId = @"13";
    m3.merchantName = @"麻辣香锅";
    m3.iconUrl = @"http://imgsrc.baidu.com/forum/pic/item/c14e7c3e6709c93d5d46bc049f3df8dcd0005461.jpg";
    m3.applauseRate = @"0.8";
    m3.merchantInfo = @"麻辣香锅发源于重庆缙云山，由川渝地方麻辣风味融合而来，麻辣香锅源于土家风味，是当地老百姓的家常做法，以麻、辣、鲜、香、油、混搭为特点。虽然麻辣香锅属于麻辣口味，但颇受全国食客喜爱。据说，四川属于盆地，也属于平原地区，湿气较重平时喜欢把一大锅菜一起用各种调料味料炒起来吃，而每当有重要的客人时，便会在平常吃的大锅炒菜中加入肉、海鲜、家禽、甚至野味，所搭配的菜品事先炸过或者过水煮过，可以吸收各种肉类和配菜的鲜味，加入本身的调料香味，混合起来以后，成就了“一锅香”";
    
    GoodsModel *x1 = [[GoodsModel alloc] init];
    x1.name = @"套餐一,建议1-2人使用";
    x1.image = @"http://img3.redocn.com/tupian/20150115/malaxiangguo_3576134.jpg";
    x1.firstPrice = @"32";
    x1.secondPrice = @"43";
    x1.sellNum = @"1354";
    
    GoodsModel *x2 = [[GoodsModel alloc] init];
    x2.name = @"套餐二,建议2-3人使用";
    x2.image = @"http://pic37.nipic.com/20140113/1184596_165339563179_2.jpg";
    x2.firstPrice = @"53";
    x2.secondPrice = @"62";
    x2.sellNum = @"1365";
    
    GoodsModel *x3 = [[GoodsModel alloc] init];
    x3.name = @"套餐三,建议2-3人使用";
    x3.image = @"http://img004.hc360.cn/g7/M04/69/8A/wKhQs1OJeFGEEn_XAAAAAJKhC-Q976.jpg";
    x3.firstPrice = @"86";
    x3.secondPrice = @"120";
    x3.sellNum = @"1360";
    
    m3.goods = [NSArray arrayWithObjects:x1,x2,x3, nil];
    
    
    
    
    MerchantModel *m4 = [[MerchantModel alloc] init];
    m4.merchantId = @"14";
    m4.merchantName = @"香羊羊火锅";
    m4.iconUrl = @"http://p5.img.brtn.cn/photoworkspace/contentimg/2014/09/04/2014090409580842683.jpg";
    m4.applauseRate = @"0.8";
    m4.merchantInfo = @"重庆火锅，又称为毛肚火锅或麻辣火锅，是汉族传统饮食方式，起源于明末清初的重庆嘉陵江畔、朝天门等码头船工纤夫的粗放餐饮方式，原料主要是牛毛肚、猪黄喉、鸭肠、牛血旺等";
    
    GoodsModel *z1 = [[GoodsModel alloc] init];
    z1.name = @"套餐一,建议1-2人使用";
    z1.image = @"http://images.517best.com/UploadFiles/images/s/20140320/40261317220140320130733105565427.jpg";
    z1.firstPrice = @"95";
    z1.secondPrice = @"143";
    z1.sellNum = @"1354";
    
    GoodsModel *z2 = [[GoodsModel alloc] init];
    z2.name = @"套餐二,建议4-7人使用";
    z2.image = @"http://images.3158.cn/data/attachment/chongqing/article/2014/05/23/5183912d3e457c5d07726c5926cb1a9f.jpg";
    z2.firstPrice = @"268";
    z2.secondPrice = @"362";
    z2.sellNum = @"1684";
    
    GoodsModel *z3 = [[GoodsModel alloc] init];
    z3.name = @"套餐三,建议3-6人使用";
    z3.image = @"http://www.hnlxgl.com/files/document/10000/2014/12/1417503276914212.jpg";
    z3.firstPrice = @"230";
    z3.secondPrice = @"290";
    z3.sellNum = @"962";
    
    m4.goods = [NSArray arrayWithObjects:z1,z2,z3, nil];
    
    
    
    
    MerchantModel *m5 = [[MerchantModel alloc] init];
    m5.merchantId = @"15";
    m5.merchantName = @"韩国烤肉";
    m5.iconUrl = @"http://img1.cache.netease.com/catchpic/2/2C/2C65CA0F8AF3FDFB630C52C96519E17D.jpg";
    m5.applauseRate = @"0.8";
    m5.merchantInfo = @"“烤肉”选料严格，肉嫩味香，自烤自食，再佐以美酒，独具风味。烤肉历史悠久，但值得一提的事，烤肉不对等于原始的刀耕火种。[1]  据《汉代画象全集》可知最起码早在两汉时期就有体系完备的烤肉烤食讲究";
    
    GoodsModel *s1 = [[GoodsModel alloc] init];
    s1.name = @"套餐一,建议1-2人使用";
    s1.image = @"http://img.taopic.com/uploads/allimg/120415/6308-12041511051080.jpg";
    s1.firstPrice = @"94";
    s1.secondPrice = @"143";
    s1.sellNum = @"154";
    
    GoodsModel *s2 = [[GoodsModel alloc] init];
    s2.name = @"套餐二,建议1-2人使用";
    s2.image = @"http://pic28.nipic.com/20130419/5056611_202403376000_2.jpg";
    s2.firstPrice = @"88";
    s2.secondPrice = @"120";
    s2.sellNum = @"684";
    
    GoodsModel *s3 = [[GoodsModel alloc] init];
    s3.name = @"套餐三,建议3-4人使用";
    s3.image = @"http://imgs.douguo.com/upload/diet/0/e/5/0ef6812f2c4e13e71da01d963c1b49e5.jpg";
    s3.firstPrice = @"190";
    s3.secondPrice = @"230";
    s3.sellNum = @"962";
    
    m5.goods = [NSArray arrayWithObjects:s1,s2,s3, nil];
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}

+ (NSArray *)getHouseData {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"16";
    m1.merchantName = @"7天连锁酒店";
    m1.iconUrl = @"http://t2.s1.dpfile.com/pc/mc/725874fbe39f2eee2e79063f8701458b%28450x1024%29/thumb.jpg";
    m1.applauseRate = @"0.5";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"17";
    m2.merchantName = @"如家快捷酒店";
    m2.iconUrl = @"http://file26.mafengwo.net/M00/7C/3D/wKgB4lKwD7OAaIpDAABRUcbScxU72.rbook_comment.w1024.jpeg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"18";
    m3.merchantName = @"速8酒店";
    m3.iconUrl = @"http://images4.c-ctrip.com/target/tuangou/588/860/767/258ea0059ff84d8db345a9d84250c38b_570_380.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"19";
    m4.merchantName = @"君悦快捷酒店";
    m4.iconUrl = @"http://t1.s2.dpfile.com/pc/mc/bf3d5e45cdf26e5bc96d3df369ee6e65%28450c280%29/thumb.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"20";
    m5.merchantName = @"汉庭酒店";
    m5.iconUrl = @"http://p1.meituan.net/deal/__30368343__2047882.jpg";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}

+ (NSArray *)getHomeData {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"21";
    m1.merchantName = @"浦城金牌月嫂中心";
    m1.iconUrl = @"http://pic1.58cdn.com.cn/vip/portal/pic/n_s12486454016592647093.jpg";
    m1.applauseRate = @"1";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"22";
    m2.merchantName = @"乐乐家政服务";
    m2.iconUrl = @"http://file5.gucn.com/file2/CurioPicfile/20120516/Gucn_20120516290550134911Pic2.jpg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"23";
    m3.merchantName = @"KK保姆站";
    m3.iconUrl = @"http://paper.tlnews.com.cn/resfile/2013-08-29/05/%D4%C2%C9%A9_b.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"24";
    m4.merchantName = @"虎纠好家政";
    m4.iconUrl = @"http://3.pic.58control.cn/p2/small/n_s12498084124890720192.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"25";
    m5.merchantName = @"云家政";
    m5.iconUrl = @"http://www.lagou.com/image1/M00/0A/FB/Cgo8PFTxKz2ATHC-AAXOU_UjeeU381.png";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}
+ (NSArray *)getKTVdata {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"26";
    m1.merchantName = @"米乐星欢乐KTV";
    m1.iconUrl = @"http://pic.58pic.com/58pic/13/08/03/83658PICUXd_1024.jpg";
    m1.applauseRate = @"0.5";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"27";
    m2.merchantName = @"音乐一KTV";
    m2.iconUrl = @"http://img.zcool.cn/community/01257356581c5932f87512f6dcdd17.jpg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"28";
    m3.merchantName = @"白宫梦想自助KTV";
    m3.iconUrl = @"http://p0.55tuanimg.com/static/goods/richText/2014/01/16/16/401298a2a28d65e0a4514f7b821ed889_690_459.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"29";
    m4.merchantName = @"欢乐量贩KTV";
    m4.iconUrl = @"http://pic.58pic.com/58pic/12/62/51/73958PIChQs.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"30";
    m5.merchantName = @"米勒量贩KTV";
    m5.iconUrl = @"http://upload.haochimei.com/product/4149/20131025173006781_9653.jpg";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}

+ (NSArray *)getTakeOutdata {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"31";
    m1.merchantName = @"炖汤世家";
    m1.iconUrl = @"http://pic19.nipic.com/20120301/7391590_174627733151_2.jpg";
    m1.applauseRate = @"0.5";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"32";
    m2.merchantName = @"芝根芝底";
    m2.iconUrl = @"http://new-img2.ol-img.com/985x695/116/526/lid2jOiUXTdG2.jpg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"33";
    m3.merchantName = @"鸡排先生";
    m3.iconUrl = @"http://f3.lashouimg.com/cms/M00/DF/D5/CqgBVFWoaq2AJsX9AAEtoBKUWCk253.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"34";
    m4.merchantName = @"小米熊寿司";
    m4.iconUrl = @"http://p1.meituan.net/deal/e169bc5d01e02da30117d65c576dc437206774.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"35";
    m5.merchantName = @"川府鱼庄";
    m5.iconUrl = @"http://pic77.nipic.com/file/20150913/19521820_111705463000_2.jpg";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}

+ (NSArray *)getConveniencedata {
    HomeShopModel *m1 = [[HomeShopModel alloc] init];
    m1.merchantId = @"336";
    m1.merchantName = @"叮叮便民服务";
    m1.iconUrl = @"http://pic33.nipic.com/20130924/8967352_161455057310_2.jpg";
    m1.applauseRate = @"0.5";
    m1.distance = @"10";
    
    HomeShopModel *m2 = [[HomeShopModel alloc] init];
    m2.merchantId = @"37";
    m2.merchantName = @"浦城便民服务";
    m2.iconUrl = @"http://pic.58pic.com/58pic/12/81/00/97p58PIChXD.jpg";
    m2.applauseRate = @"0.1";
    m2.distance = @"1200";
    
    
    HomeShopModel *m3 = [[HomeShopModel alloc] init];
    m3.merchantId = @"38";
    m3.merchantName = @"世纪城便民服务";
    m3.iconUrl = @"http://pic.qiantucdn.com/58pic/16/68/00/60T58PICNQZ_1024.jpg";
    m3.applauseRate = @"0.8";
    m3.distance = @"2100";
    
    HomeShopModel *m4 = [[HomeShopModel alloc] init];
    m4.merchantId = @"39";
    m4.merchantName = @"安飞士便民服务";
    m4.iconUrl = @"http://img.sccnn.com/bimg/337/48196.jpg";
    m4.applauseRate = @"0.2";
    m4.distance = @"3200";
    
    HomeShopModel *m5 = [[HomeShopModel alloc] init];
    m5.merchantId = @"40";
    m5.merchantName = @"顶邦便民";
    m5.iconUrl = @"http://cms.wlmqwb.com/upload/2014/07/small_news_0.649912806530442.jpg";
    m5.applauseRate = @"0.6";
    m5.distance = @"3540";
    
    
    
    NSArray *arr = [NSArray arrayWithObjects:m1,m2,m3,m4,m5, nil];
    return arr;
}


+ (NSArray *)getMerchantCategory{
    MerchantCategoryModel *m1 = [MerchantCategoryModel new];
    m1.categoryId = @"1";
    m1.categoryName = @"便民";
    m1.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m2 = [MerchantCategoryModel new];
    m2.categoryId = @"2";
    m2.categoryName = @"政务";
    m2.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m3 = [MerchantCategoryModel new];
    m3.categoryId = @"3";
    m3.categoryName = @"拼车";
    m3.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m4 = [MerchantCategoryModel new];
    m4.categoryId = @"4";
    m4.categoryName = @"服务";
    m4.iconUrl = @"http://www.baidu.com";
    
    
    MerchantCategoryModel *m5 = [MerchantCategoryModel new];
    m5.categoryId = @"5";
    m5.categoryName = @"酒店";
    m5.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m6 = [MerchantCategoryModel new];
    m6.categoryId = @"5";
    m6.categoryName = @"出行";
    m6.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m7 = [MerchantCategoryModel new];
    m7.categoryId = @"7";
    m7.categoryName = @"美食";
    m7.iconUrl = @"http://www.baidu.com";
    
    MerchantCategoryModel *m8 = [MerchantCategoryModel new];
    m8.categoryId = @"8";
    m8.categoryName = @"其他";
    m8.iconUrl = @"http://www.baidu.com";
    
    return [NSArray arrayWithObjects:m1, m2, m3, m4, m5, m6, m7, m8, nil];
}




+ (NSArray *)getGovData{
    GovModel *m1 = [[GovModel alloc] init];
    m1.titile = @"县人大副主任任全虎深入包联镇检查指导工作";
    m1.subTitile = @"5月4日，县人大副主任任全虎深入包联的党睦镇有关村组督查指导基层党";
    m1.targetUrl = @"http://www.pucheng.gov.cn/xwzx/bdyw/59481.htm";
    m1.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    GovModel *m2 = [[GovModel alloc] init];
    m2.titile = @"高阳镇2016年“三公”经费支出预算表";
    m2.subTitile = @"高阳镇2016年“三公”经费支出预算表";
    m2.targetUrl = @"http://www.pucheng.gov.cn/gk/bmgk10/59511.htm";
    m2.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    
    GovModel *m3 = [[GovModel alloc] init];
    m3.titile = @"党睦镇预算收支总表";
    m3.subTitile = @"党睦镇预算收支总表";
    m3.targetUrl = @"http://www.pucheng.gov.cn/gk/bmgk09/59504.htm";
    m3.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    
    GovModel *m4 = [[GovModel alloc] init];
    m4.titile = @"我县召开脱贫攻坚工作座谈会";
    m4.subTitile = @"5月6日上午，我县召开脱贫攻坚工作座谈会。县委常委、统战部长刘万年，副县长张新庄出席会";
    m4.targetUrl = @"http://www.pucheng.gov.cn/xwzx/bdyw/59560.htm";
    m4.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    GovModel *m5 = [[GovModel alloc] init];
    m5.titile = @"县长李军政检查花炮安全生产工作";
    m5.subTitile = @"5月4日上午，县长李军政深入兴镇、桥陵镇，重点就当前花炮安全生";
    m5.targetUrl = @"http://www.pucheng.gov.cn/xwzx/bdyw/59400.htm";
    m5.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    GovModel *m6 = [[GovModel alloc] init];
    m6.titile = @"我县召开安全生产百日专项整治动员会";
    m6.subTitile = @"4月29日上午，我县召开安全生产百日专项整治动员会。会议分析";
    m6.targetUrl = @"http://www.pucheng.gov.cn/xwzx/bdyw/59274.htm";
    m6.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    GovModel *m7 = [[GovModel alloc] init];
    m7.titile = @"中小学生转学流程";
    m7.subTitile = @"中小学生转学流程";
    m7.targetUrl = @"http://www.pucheng.gov.cn/jybw/pjjy/gzjy/25754.htm";
    m7.imageUrl = @"http://www.pucheng.gov.cn/wcm.files/upload/CMSpc/201604/201604271038033.jpg";
    
    return [NSArray arrayWithObjects:m1, m2, m3, m4, m5, m6, m7, nil];
}

+ (NSArray *)getAdressData {

    AdressModel *m1 = [[AdressModel alloc] init];
    m1.userName = @"赵帅";
    m1.addressId = @"123";
    m1.isDefault = 1;
    m1.address = @"福州市晋安区鼓四村";
    m1.mobile = @"1234567841";
    
    AdressModel *m2 = [[AdressModel alloc] init];
    m2.userName = @"福贵";
    m2.isDefault = 0;
    m2.addressId = @"124";
    m2.address = @"福州市软件园";
    m2.mobile = @"12354683657";
    
    
    AdressModel *m3 = [[AdressModel alloc] init];
    m3.userName = @"林贤辉";
    m3.addressId = @"125";
    m3.isDefault = 0;
    m3.address = @"福州市晋安区福新中路永同昌大厦";
    m3.mobile = @"115036589345";
    
    return  @[m1, m2, m3];
}

+ (NSArray *)getTalkPictureData {
    NSArray *arr = [NSArray arrayWithObjects:@"http://pic4.nipic.com/20091022/3548141_102749135821_2.jpg",@"http://dimg04.c-ctrip.com/images/fd/vacations/g1/M04/E5/B2/CghzflTbEo6Ae8ytAAKA2s7yoTU025_C_500_280.jpg",@"http://imgsrc.baidu.com/baike/pic/item/8326cffc1e178a829bec9484f403738da877e8c6.jpg",@"http://imgsrc.baidu.com/baike/pic/item/8326cffc1e178a829bec9484f403738da877e8c6.jpg",@"http://pic9.nipic.com/20100903/5483130_133803793654_2.jpg",@"http://a0.att.hudong.com/62/53/01200000033394115605367449362.jpg", nil];
    return arr;
}





@end
