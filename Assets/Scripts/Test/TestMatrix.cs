using UnityEngine;

namespace Test {

public class TestMatrix : MonoBehaviour {
    private void Start() {
        const float near = 1;
        const float far = 16;
        const float halfFov = Mathf.Deg2Rad * 30;
        const float aspect = 1920f / 1080f;
        var top = near * Mathf.Tan(halfFov);
        var right = top * aspect;
        var frustum = Matrix4x4.Frustum(-right, right, -top, top, near, far);
        var t = new Matrix4x4();

        var vp1 = new Vector4(1, 2, -3, 1);
        var vp2 = new Vector4(3, 6, -7, 1);
        var vp3 = (vp1 + vp2) / 2;

        var fp1 = frustum * vp1;
        var fp2 = frustum * vp2;
        var fp3 = frustum * vp3;
        var fp4 = (fp1 + fp2) / 2;

        var sp1 = fp1 / fp1.w;
        var sp2 = fp2 / fp2.w;
        var sp3 = fp3 / fp3.w;
        var sp4 = fp4 / fp4.w;

        var mp1 = frustum.MultiplyPoint(vp1);
        var mp2 = frustum.MultiplyPoint(vp2);
        var mp3 = frustum.MultiplyPoint(vp3);
        var mp4 = (mp1 + mp2) / 2;

        Debug.Log("Output of TestMatrix:"
                + "\n vp1 = " + (Vector3)vp1 + ", vp2 = " + (Vector3)vp2 + ", vp3 = " + (Vector3)vp3
                + "\n fp1 = " + (Vector3)fp1 + ", fp2 = " + (Vector3)fp2 + ", fp3 = " + (Vector3)fp3 + ", fp4 = " + (Vector3)fp4
                + "\n sp1 = " + (Vector3)sp1 + ", sp2 = " + (Vector3)sp2 + ", sp3 = " + (Vector3)sp3 + ", sp4 = " + (Vector3)sp4
                + "\n mp1 = " + (Vector3)mp1 + ", mp2 = " + (Vector3)mp2 + ", mp3 = " + (Vector3)mp3 + ", mp4 = " + (Vector3)mp4
        );
    }
}

}
