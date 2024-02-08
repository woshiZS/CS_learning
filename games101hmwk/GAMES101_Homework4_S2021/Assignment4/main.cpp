#include <chrono>
#include <iostream>
#include <opencv2/opencv.hpp>
#include <math.h>

std::vector<cv::Point2f> control_points;

void mouse_handler(int event, int x, int y, int flags, void *userdata) 
{
    if (event == cv::EVENT_LBUTTONDOWN && control_points.size() < 4) 
    {
        std::cout << "Left button of the mouse is clicked - position (" << x << ", "
        << y << ")" << '\n';
        control_points.emplace_back(x, y);
    }     
}

void naive_bezier(const std::vector<cv::Point2f> &points, cv::Mat &window) 
{
    auto &p_0 = points[0];
    auto &p_1 = points[1];
    auto &p_2 = points[2];
    auto &p_3 = points[3];

    for (double t = 0.0; t <= 1.0; t += 0.001) 
    {
        auto point = std::pow(1 - t, 3) * p_0 + 3 * t * std::pow(1 - t, 2) * p_1 +
                 3 * std::pow(t, 2) * (1 - t) * p_2 + std::pow(t, 3) * p_3;

        window.at<cv::Vec3b>(point.y, point.x)[2] = 255;
    }
}

cv::Point2f recursive_bezier(const std::vector<cv::Point2f> &control_points, float t) 
{
    // TODO: Implement de Casteljau's algorithm
    if(control_points.size() == 1)
        return control_points[0];
    std::vector<cv::Point2f> next_points;
    for(int i = 1; i < control_points.size(); ++i)
    {
        cv::Point2f temp = control_points[i - 1] + t * (control_points[i] - control_points[i - 1]);
        next_points.push_back(temp);
    }
    return recursive_bezier(next_points, t);
}

void bezier(const std::vector<cv::Point2f> &control_points, cv::Mat &window) 
{
    // TODO: Iterate through all t = 0 to t = 1 with small steps, and call de Casteljau's 
    // recursive Bezier algorithm.
    
    for(double t = 0.0; t <= 1.0; t += 0.001)
    {
        auto point = recursive_bezier(control_points, t);
        window.at<cv::Vec3b>(point.y, point.x)[1] = 255;

        int dis_x = point.x, dis_y = point.y;
        double center_x = dis_x + 0.5, center_y = dis_y + 0.5;
        double dir[4][2] = 
        {
            {1.0, -1.0}, {1.0, 1.0}, {-1.0, -1.0}, {-1.0, 1.0}
        };
        double delta_x = point.x - center_x, delta_y = point.y - center_y;
        int idx = (delta_x >= 0 ? 0 : 2) + (delta_y >= 0 ? 1 : 0);

        double d1 = norm(point - cv::Point2f(center_x + dir[idx][0], center_y));
        double d2 = norm(point - cv::Point2f(center_x, center_y + + dir[idx][1]));
        double d3 = norm(point - cv::Point2f(center_x + dir[idx][0], center_y + dir[idx][1]));
        double d = norm(point - cv::Point2f(center_x, center_y));

        window.at<cv::Vec3b>(center_y, center_x + dir[idx][0])[1] = std::max(255.0 * d / d1, double(window.at<cv::Vec3b>(center_y, center_x + dir[idx][0])[1]));
        window.at<cv::Vec3b>(center_y + dir[idx][1], center_x)[1] = std::max(255.0 * d / d2, double(window.at<cv::Vec3b>(center_y + dir[idx][1], center_x)[1]));
        window.at<cv::Vec3b>(center_y + dir[idx][1], center_x + dir[idx][0])[1] = std::max(255.0 * d / d3, double(window.at<cv::Vec3b>(center_y + dir[idx][1], center_x + dir[idx][0])[1]));

    }
}

int main() 
{
    cv::Mat window = cv::Mat(700, 700, CV_8UC3, cv::Scalar(0));
    cv::cvtColor(window, window, cv::COLOR_BGR2RGB);
    cv::namedWindow("Bezier Curve", cv::WINDOW_AUTOSIZE);

    cv::setMouseCallback("Bezier Curve", mouse_handler, nullptr);

    int key = -1;
    while (key != 27) 
    {
        for (auto &point : control_points) 
        {
            cv::circle(window, point, 3, {255, 255, 255}, 3);
        }

        if (control_points.size() == 4) 
        {
            // naive_bezier(control_points, window);
            bezier(control_points, window);

            cv::imshow("Bezier Curve", window);
            cv::imwrite("my_bezier_curve.png", window);
            key = cv::waitKey(0);

            return 0;
        }

        cv::imshow("Bezier Curve", window);
        key = cv::waitKey(20);
    }

return 0;
}
