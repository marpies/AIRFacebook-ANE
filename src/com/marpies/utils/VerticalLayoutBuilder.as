package com.marpies.utils {

    import feathers.layout.VerticalLayout;

    public class VerticalLayoutBuilder {

        private var mLayout:VerticalLayout;

        public function VerticalLayoutBuilder() {
            mLayout = new VerticalLayout();
        }

        public function setGap( gap:Number ):VerticalLayoutBuilder {
            mLayout.gap = gap;
            return this;
        }

        public function setFirstGap( gap:Number ):VerticalLayoutBuilder {
            mLayout.firstGap = gap;
            return this;
        }

        public function setLastGap( gap:Number ):VerticalLayoutBuilder {
            mLayout.lastGap = gap;
            return this;
        }

        public function setPadding( padding:Number ):VerticalLayoutBuilder {
            mLayout.padding = padding;
            return this;
        }

        public function setHorizontalAlign( align:String ):VerticalLayoutBuilder {
            mLayout.horizontalAlign = align;
            return this;
        }

        public function setVerticalAlign( align:String ):VerticalLayoutBuilder {
            mLayout.verticalAlign = align;
            return this;
        }

        public function build():VerticalLayout {
            return mLayout;
        }

    }

}
