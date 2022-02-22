using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class ShowNavmeshInGame : MonoBehaviour
{

    private const int SetBound = UInt16.MaxValue - 3;
    private int _nameSuffix = 0;

    void Start () {
		//ShowMesh();
        SplitMeshData();
	}

    void ShowMesh()
    {
        NavMeshTriangulation meshData = NavMesh.CalculateTriangulation();

        var triangleData = meshData.areas;

        Mesh mesh = new Mesh();
        mesh.vertices = meshData.vertices;
        mesh.triangles = meshData.indices;

        var meshFilter = GetComponent<MeshFilter>();
        if (meshFilter == null)
            meshFilter = gameObject.AddComponent<MeshFilter>();
        meshFilter.mesh = mesh;

        var meshRenderer = GetComponent<MeshRenderer>();
        if (meshRenderer == null)
            meshRenderer = gameObject.AddComponent<MeshRenderer>();
        meshRenderer.material = new Material(Shader.Find("Sprites/Default"));
        SetMaterialTransparent(meshRenderer.material);
        gameObject.transform.position = new Vector3(0, 0.1f, 0);
    }

    void SetMaterialTransparent(Material material)
    {
        material.SetOverrideTag("RenderType", "Transparent");
        material.SetFloat("_SrcBlend", (float)UnityEngine.Rendering.BlendMode.One);
        material.SetFloat("_DstBlend", (float)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
        material.SetFloat("_ZWrite", 0.0f);
        material.DisableKeyword("_ALPHATEST_ON");
        material.DisableKeyword("_ALPHABLEND_ON");
        material.EnableKeyword("_ALPHAPREMULTIPLY_ON");
        material.renderQueue = (int)UnityEngine.Rendering.RenderQueue.Transparent;
        material.SetColor("_Color", new Color(0, 1f, 1f, 0.4f));
    }

    
    void SplitMeshData()
    {
        NavMeshTriangulation meshData = NavMesh.CalculateTriangulation();
        var totalMeshVertexCount = meshData.vertices.Length;
        var splitCondition = totalMeshVertexCount >= UInt16.MaxValue;
        if (splitCondition)
        {
            // 遍历三角形，直到顶点集合快满
            // triangleIndices: 三角形对应点的数组，三个一组
            // vertexContainer: 遍历到当前位置所需要的顶点集合
            // 分割结束挂载mesh到GameObject之后需要clear原有set
            var triangleIndices = meshData.indices;
            var triangleBound = triangleIndices.Length;
            HashSet<int> vertexContainer = new HashSet<int>();
            for (int i = 0; i < triangleBound; i += 3)
            {
                vertexContainer.Add(triangleIndices[i]);
                vertexContainer.Add(triangleIndices[i + 1]);
                vertexContainer.Add(triangleIndices[i + 2]);
                if (vertexContainer.Count > SetBound)
                {
                    // 将set数据排序，并且做一个原来index对应新index的映射，或者用二分
                    var resultCount = vertexContainer.Count;
                    int[] freshVertexArray = new int[resultCount];
                    vertexContainer.CopyTo(freshVertexArray);
                    vertexContainer.Clear();
                    Array.Sort(freshVertexArray);
                    Mesh mesh = new Mesh();
                    // 这些点的数据用之前记录的index去填
                    var freshIndexCount = i + 3;
                    Vector3[] tempVertexes = new Vector3[resultCount];
                    int[] tempTriangles = new int[freshIndexCount];
                    for (int j = 0; j < resultCount; ++j)
                    {
                        tempVertexes[j] = meshData.vertices[freshVertexArray[j]];
                    }
                    // 新添加triangleIndex也需要更新，用原有的三角形数组去现在的顶点数组（freshVertexArray)里面去做二分
                    for (int j = 0; j < freshIndexCount; ++j)
                    {
                        tempTriangles[j] = BinarySearch(freshVertexArray, triangleIndices[j]);
                    }
                    // 至此，一个分块的meshData处理完毕，剩下的工作就是设置透明度和颜色
                    mesh.vertices = tempVertexes;
                    mesh.triangles = tempTriangles;
                    var tempMeshGo = CreateGoAndSetMesh();
                    var meshFilter = tempMeshGo.GetComponent<MeshFilter>();
                    meshFilter.mesh = mesh;
                }
            }
        }
        else
        {
            Mesh mesh = new Mesh();
            mesh.vertices = meshData.vertices;
            mesh.triangles = meshData.indices;
            var tempGo = CreateGoAndSetMesh();
            var meshFilter = tempGo.GetComponent<MeshFilter>();
            meshFilter.mesh = mesh;
        }
    }

    private int BinarySearch(int[] container, int target)
    {
        // search target in the container
        var containerLen = container.Length;
        int leftBound = 0, rightBound = containerLen - 1, mid = 0;
        while (leftBound < rightBound)
        {
            mid = (rightBound - leftBound) / 2 + leftBound;
            var midContent = container[mid];
            if (midContent == target)
                break;
            else if (midContent > target)
                rightBound = mid;
            else
                leftBound = mid + 1;
        }

        return mid;
    }

    private GameObject CreateGoAndSetMesh()
    {
        GameObject dummyObject = new GameObject("GoForMesh_" + _nameSuffix++);
        dummyObject.AddComponent<MeshFilter>();
        var meshRenderer = dummyObject.AddComponent<MeshRenderer>();
        meshRenderer.material = new Material(Shader.Find("Sprites/Default"));
        SetMaterialTransparent(meshRenderer.material);
        dummyObject.transform.position = new Vector3(0, 0.1f, 0);
        return dummyObject;
    }
}
