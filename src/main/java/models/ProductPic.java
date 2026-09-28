package models;

import java.io.Serializable;

public class ProductPic implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer productPicId;
    private Integer productId;
    private String picPath;
    private Boolean mainPic;

    public ProductPic() {
    }

    public ProductPic(Integer productPicId, Integer productId, String picPath, Boolean mainPic) {
        this.productPicId = productPicId;
        this.productId = productId;
        this.picPath = picPath;
        this.mainPic = mainPic;
    }

    public Integer getProductPicId() {
        return productPicId;
    }

    public void setProductPicId(Integer productPicId) {
        this.productPicId = productPicId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getPicPath() {
        return picPath;
    }

    public void setPicPath(String picPath) {
        this.picPath = picPath;
    }

    public Boolean getMainPic() {
        return mainPic;
    }

    public void setMainPic(Boolean mainPic) {
        this.mainPic = mainPic;
    }
}
