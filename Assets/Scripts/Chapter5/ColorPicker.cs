/// <summary>
/// Author: Lele Feng 
/// </summary>

using UnityEngine;
using System.Collections;

public class ColorPicker : MonoBehaviour {
	
	private Camera _camera;
	public BoxCollider pickerCollider;

	private bool _grab;
	private Texture2D _screenRenderTexture;
	
	private Texture2D _rectTexture;
	private GUIStyle _rectStyle;
	private Vector3 _pixelPosition = Vector3.zero;
	private Color _pickedColor = Color.white;

	private void Awake() {
		// Get the Camera component
		_camera = GetComponent<Camera>();
		if (_camera == null) {
			Debug.LogError("You need to dray this script to a camera!");
			return;
		}

		// Attach a BoxCollider to this camera
		// In order to receive mouse events
		if (pickerCollider != null) return;
		pickerCollider = gameObject.AddComponent<BoxCollider>();
		// Make sure the collider is in the camera's frustum
		pickerCollider.center = Vector3.zero;
		pickerCollider.center += _camera.transform.worldToLocalMatrix.MultiplyVector(_camera.transform.forward) * (_camera.nearClipPlane + 0.05f);
		pickerCollider.size = new Vector3(Screen.width, Screen.height, 0.1f);
	}

	private void OnMouseDown() {
		_grab = true;
		// Record the mouse position to pick pixel
		_pixelPosition = Input.mousePosition;
	}

	// OnPostRender is called after a camera has finished rendering the scene.
	// This message is sent to all scripts attached to the camera.
	// Use it to grab the screen
	// Note: grabbing is a expensive operation
	private void OnPostRender() {
		if (!_grab) return;
		_screenRenderTexture ??= new Texture2D(Screen.width, Screen.height);
		_screenRenderTexture.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0);
		_screenRenderTexture.Apply();
		_pickedColor = _screenRenderTexture.GetPixel(Mathf.FloorToInt(_pixelPosition.x), Mathf.FloorToInt(_pixelPosition.y));
		_grab = false;
	}

	private void OnGUI() {
		GUI.Box(new Rect(0, 0, 120, 200), "Color Picker");
		GUIDrawRect(new Rect(20, 30, 80, 80), _pickedColor);
		GUI.Label(new Rect(10, 120, 100, 20), "R: " + System.Math.Round((double)_pickedColor.r, 4) + "\t(" + Mathf.FloorToInt(_pickedColor.r * 255)+ ")");
		GUI.Label(new Rect(10, 140, 100, 20), "G: " + System.Math.Round((double)_pickedColor.g, 4) + "\t(" + Mathf.FloorToInt(_pickedColor.g * 255)+ ")");
		GUI.Label(new Rect(10, 160, 100, 20), "B: " + System.Math.Round((double)_pickedColor.b, 4) + "\t(" + Mathf.FloorToInt(_pickedColor.b * 255)+ ")");
		GUI.Label(new Rect(10, 180, 100, 20), "A: " + System.Math.Round((double)_pickedColor.a, 4) + "\t(" + Mathf.FloorToInt(_pickedColor.a * 255)+ ")");
	}

	// Draw the color we picked
	private void GUIDrawRect( Rect position, Color color )
	{
		_rectTexture ??= new Texture2D(1, 1);
		
		_rectStyle ??= new GUIStyle();
		
		_rectTexture.SetPixel(0, 0, color);
		_rectTexture.Apply();
		
		_rectStyle.normal.background = _rectTexture;
		
		GUI.Box(position, GUIContent.none, _rectStyle);
	}
}
